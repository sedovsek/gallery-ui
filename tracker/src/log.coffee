fs        = require 'fs'
constants = require 'constants'

#
# Atomic log file
# (file is created and buffers are written atomically)
# 
# Descriptor is closed after there are no writes for a second.
#
class Log
    constructor: (path) ->
        @path     = path
        @flushing = false
        @pending  = []
    
    write: (buffer) ->
        if buffer.length > 4000
            return console.warn "Ignoring log line larger than 4k (writes larger than ~PIPE_BUF may not be atomic): " +
                                buffer.toString('utf8', 0, 2048) + "... (snipped at 2k)" # limit to 2k, in case it's gigabytes large :)
        @pending.push buffer
        @flushIfNeeded()
    
    flushIfNeeded: ->
        return if @flushing or !@pending.length
        @flushing = true
        
        # Create file if it does not yet exist
        #
        # Just opening it with 'w' or 'a' might cause 2 processes to check if
        # it exists, find that it doesn't, and then create it (the second
        # overwriting the first).
        #
        fs.open @path, constants.O_CREAT, 0o0666, (err, fd) =>
            if fd
                console.log "Created log file: #{@path}"
                fs.close fd
                fd = null
            
            # Open file for append
            fs.open @path, 'a', 0o0666, (err, fd) =>
                throw err if err
                
                iter = =>
                    if @pending.length
                        # Pending writes: write one then repeat
                        buffer = @pending.shift()
                        fs.write fd, buffer, 0, buffer.length, null, (err, written) =>
                            throw err if err
                            throw "Buffer is #{buffer.length} bytes long, but written only #{written}" if written != buffer.length
                            iter()
                    else
                        # No pending writes: close file
                        @flushing = false
                        fs.close fd, (err) =>
                            throw err if err
                iter()

module.exports = Log