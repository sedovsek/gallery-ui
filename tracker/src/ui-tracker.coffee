fs   = require 'fs'
os   = require 'os'
url  = require 'url'
http = require 'http'
Log  = require './log.js'

events = []

record = (event) ->
    return unless event = event.query?.event
    events.push { "event" : JSON.parse event }

reset = ->
    events = []

flush = ->
    return unless config.logDir

    now = new Date

    logDir = './'+config.logDir+'/'
    fs.mkdirSync logDir if not fs.existsSync logDir

    events.forEach (event) =>
        event.timestamp = now/1000
        event.receiverHostname = os.hostname()

        # Build log name
        pad = (n) -> if n < 10 then '0'+n else n+''
        # Hourly log file
        logPath = logDir + "#{pad now.getUTCFullYear()}-#{pad now.getUTCMonth()+1}-#{pad now.getUTCDate()}_#{pad now.getUTCHours()}"
        # Open log file
        if !@currentLog or @currentLog.path != logPath
            @currentLog = new Log logPath

        # Write!
        @currentLog.write new Buffer JSON.stringify(event) + '\n'

    reset()

server = http.createServer (request, response) ->
    params = url.parse request.url, true
    if params.pathname is '/pixel.gif'
        response.writeHead 200, pixelHeaders
        response.end pixel
        record params

configPath = process.argv[2]
if not configPath or (configPath in ['-h', '-help', '--help'])
    console.error "Usage: bin/ui-tracker path/to/config.json"
    process.exit 0

config = JSON.parse fs.readFileSync(configPath).toString()
pixel  = fs.readFileSync __dirname + '/pixel.gif'

if config.logDir
    console.info "Flushing hits to #{config.logDir}"
else
    console.warn "No log directory set. Events won't be flushed, add \"logDir\" to #{configPath}."
    process.exit 0

# HTTP headers for the pixel image.
pixelHeaders =
    'Cache-Control'       : 'private, no-cache, proxy-revalidate, max-age=0'
    'Content-Type'        : 'image/gif'
    'Content-Disposition' : 'inline'
    'Content-Length'      : pixel.length

# Don't let exceptions kill the server.
process.on 'uncaughtException', (err) ->
    console.error "Uncaught Exception: #{err}"

# Start the server listening for pixel hits, and begin the periodic data flush.
server.listen config.port, config.host
setInterval flush, config.interval * 1000