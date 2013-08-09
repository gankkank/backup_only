db = require("../config/database").conn2
User = require("../models/user").User(db)

module.exports = (store, app) ->
  app.post "/signin", (req, res) ->
    console.log req.body
    User.find { username: req.body.username, passhash: req.body.password } , (err, user) ->
      res.send err if err
      console.log user
      if user.length is 0
        res.send "wrong username/password"
      else
        collection = db.model("mysessions")
        session = new collection( sid: req.cookies["connect.sid"])
        session.save (err) ->
          store.set req.cookies["connect.sid"], (err, result) ->
            console.log result
            res.send "hello #{session.data.username}"
  app.get "/signout", (req, res) ->
    store.destroy sid: req.cookies["connect.sid"], (err, result) ->
      console.log result
      res.send "ok"
  app.get "/sessions", (req, res) ->
    store.all (err, sessions) ->
      res.send sessions
   

