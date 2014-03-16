fs          = require 'fs'
os          = require 'os'
url         = require 'url'
http        = require 'http'
querystring = require 'querystring'
Log         = require './log.js'

@events = {}

record = (params) ->
    return unless key = params.query?.key
    @events[key] or= 0
    @events[key] +=  1

reset = ->
    @events = {}

flush = ->
    return unless config.logDir

    now = new Date

    logDir = './'+config.logDir+'/'
    fs.mkdirSync logDir if not fs.existsSync logDir

    event = { apes: '3' } 

    event.timestamp = now/1000
    event.receiver = 'tracker'
    event.receiverHostname = os.hostname()

    # Build log name
    interval = config.interval
    from = Math.floor(event.timestamp/interval)*interval
    from = new Date from*1000

    pad = (n) -> if n < 10 then '0'+n else n+''
    # throw 'Seconds is not 0?' if from.getUTCSeconds() != 0
    # throw 'Hostname contains _?' if event.receiverHostname.indexOf('_') != -1

    logPath = logDir + "#{pad from.getUTCFullYear()}-#{pad from.getUTCMonth()+1}-#{pad from.getUTCDate()}_#{pad from.getUTCHours()}-#{pad from.getUTCMinutes()}_#{event.receiverHostname}.events"
    # Open log file
    if !@currentLog or @currentLog.path != logPath
        @currentLog = new Log logPath

    # Write!
    @currentLog.write new Buffer JSON.stringify(event) + '\n'

server = http.createServer (req, res) ->
    params = url.parse req.url, true
    if params.pathname is '/pixel.gif'
        res.writeHead 200, pixelHeaders
        res.end pixel
        record params

configPath = process.argv[2]
config     = JSON.parse fs.readFileSync(configPath).toString()
pixel      = fs.readFileSync __dirname + '/pixel.gif'

if not configPath or (configPath in ['-h', '-help', '--help'])
    console.error "Usage: ui-tracker path/to/config.json"
    process.exit 0

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