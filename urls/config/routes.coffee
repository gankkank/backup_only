express = require "express"
db = require("../config/database").conn2
User = require("../models/user").User(db)
#MongooseStore = require "../config/session"
MongooseStore = require("../config/express-mongodb")(express)
options =
  connection: db,
  collection: "mysessions"
  clear_interval: 3600
sessionStore = new MongooseStore(options)


nagios = require('../controllers/nagios')
source = require('../controllers/source')
user = require('../controllers/user')


accounts = [
  { username: "gankgu001", password: "6116abc" },
  { username: "gankgu002", password: "6116abc" }
]

auth = (req, res, next) ->
  if req.session.username
    next()
  else
    res.send "login first"

module.exports = (app) ->
  app.use express.session( cookie: { maxAge: 60000},secret: "This is express-mongodb secret", store: sessionStore)
  #app.set "views", __dirname + "/views"
  #app.set "view engine", "jade"
  app.get "/nagios/search/:type",auth, nagios.search.type
  app.get "/source/search/:type",auth, source.search.type
  app.get "/signup", user.signup
  app.get "/signin", user.signin
  app.post "/signup", user.register
  #sessions:
  app.post "/signin", (req, res) ->
    console.log req.body
    console.log req.cookies["connect.sid"]
    User.find { username: req.body.username, passhash: req.body.password } , (err, user) ->
      res.send err if err
      console.log user
      if user.length is 0
        res.send "wrong username/password"
      else
        collection = db.model("mysessions")
        session = new collection( sid: "#{req.cookies["connect.sid"]}", lastAcess: new Date(), expires: new Date() + "90000", data: {})
        session.save (err) ->
          sessionStore.set req.cookies["connect.sid"], {}, (err, result) ->
            res.send err if err
            console.log result
            res.send "hello #{req.body.username}"
  app.get "/signout", (req, res) ->
    sessionStore.destroy sid: req.cookies["connect.sid"], (err, result) ->
      console.log result
      res.send "ok"
  app.get "/sessions", (req, res) ->
    console.log req.cookie
    console.log req.cookies
    console.log req.cookies["connect.sid"]
    console.log req.session
    console.log req.sessions
    sessionStore.all (err, sessions) ->
      res.send sessions


###
  #app.get "/sessions", (req, res) ->
  #  sessionStore.all (err, sessions) ->
  #    res.send err if err
  #    res.send sessions
  app.get "/sessions", (req, res) ->
    console.log req.cookies
    #res.send "ok"
    collection = db.model("mysessions")
    collection.find {}, (err, sessions) ->
      res.send err if err
      res.send sessions
  app.post "/login", (req, res) ->
    #console.log req.cookies["connect.sid"]
    if req.body.username is accounts[1].username and req.body.password is accounts[1].password
      collection = db.model("mysessions")
      session = new collection( sid: req.cookies["connect.sid"], lastAccess: new Date(), expires: new Date() + "90000", data: { username: req.body.username })
      console.log session
      session.save (err) ->
        res.send err if err
        res.send "ok"
    else
      res.send "failed"
  app.get "/logout", session.destroy
  app.post "/login", (req, res) ->
    console.log req.body
    console.log accounts[1]
    if req.body.username is accounts[1].username and req.body.password is accounts[1].password
      req.session.username = req.body.username
      res.send "ok"
    else
      res.send "failed"
  app.get "/logout", (req, res) ->
    if req.session.username
      req.session.destroy()
      res.send "deleted: #{req.session.username}"
    else
      res.send "login first"
###
