db = require("../config/database").conn2
User = require("../models/user").User(db)

signup = (req, res) ->
  res.render "users/signup", { title: "signup"}

register = (req, res) ->
  user1 = new User( username: req.body.username, email: req.body.email, passhash: req.body.password, created_at: new Date(), updated_at: new Date(), salt: "samplesalt")
  user1.save (err) ->
    res.send err if err
    res.send "ok"

signin = (req, res) ->
  res.render "users/signin", { title: "login"}

logon = (req, res) ->
  User.find { username: req.body.username, passhash: req.body.password } , (err, user) ->
    res.send "wrong username/password" if err
    res.send "hello #{user}" if user
exports.signup = signup
exports.signin = signin
exports.register = register
exports.logon = logon
