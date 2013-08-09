module.exports = (app, store, db) ->
  app.post "/signin", (req, res) ->
    User = require("../models/user")(db)
    console.log req.body, req.cookies
    User.findOne { username: req.body.username, passhash: req.body.password }, (err, user) ->
      res.send err if err
      res.send user
  app.get "/signin", (req, res) ->
    console.log req.body, req.cookies
    res.render "users/signin", { title: "signin"}
  app.get "/sessions", (req, res) ->
    console.log req.body, req.cookies, req.cookies['sid']
    sid = req.cookies['connect.sid']
    console.log sid
    store.all (err, sessions) ->
      res.send err if err
      res.send sessions
  app.get "/sessions/get", (req, res) ->
    console.log req.sessionID
    d = new Date
    console.log d.toLocaleTimeString()
    store.get req.sessionID, (err,data) ->
      console.log  err if err
      #
      #@if data.cookie.count
      #  data.cookie.count += 1
      #else
      data.cookie.count = 1
      store.set req.sessionID, data, (err, result) ->
        console.log err if err
        console.log result
      #
      expires = data.cookie.expires
      res.send expires.toLocaleString()
