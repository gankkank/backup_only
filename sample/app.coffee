express = require "express"
http = require "http"
path = require "path"
app = express()

MongooseStore = require("./lib/express-mongodb")(express)
db = require("./configs/database").conn1
options = {
  connection: db
  collection: "mysessions"
  clear_interval: 3600
}
sessionStore = new MongooseStore(options)

port = process.env.OPENSHIFT_INTERNAL_PORT or process.env.PORT or 3000
addr = process.env.OPENSHIFT_INTERNAL_IP or process.env.IP or "0.0.0.0"

_24Hours = 24 * 60 * 60 * 1000
_1Month = 30 * 24 * 60 * 60 * 1000

db.on "error", (err) ->
  console.log "err occurred: #{err}"

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + 'views'
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session(
    cookie: { maxAge: _24Hours * 5 }
    secret: "my secret"
    store: sessionStore
  )
  app.use express.static("#{__dirname}/js") #, { maxAge: _1Month })
  app.use app.router
  app.use express.static("#{__dirname}/public") #, { maxAge: _1Month })

app.configure "development", ->
  app.use express.errorHandler()

auth = (req, res, next) ->
  if req.session.username?
    next()
  else
    #console.log req.sessionID
    res.redirect "/signin"

resource = require("./lib/resource")(app, db)
resource "v1", "home"
resource "v1", "sources"

app.get "/", (req, res) -> res.send "ok"
app.get "/signin", (req, res) -> res.send "not authorized"

http.createServer(app).listen app.get("port"), ->
  console.log "Express Listening on port #{app.get 'port'}"
