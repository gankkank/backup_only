(function() {
  var User, db, logon, register, signin, signup;

  db = require("../config/database").conn2;

  User = require("../models/user").User(db);

  signup = function(req, res) {
    return res.render("users/signup", {
      title: "signup"
    });
  };

  register = function(req, res) {
    var user1;

    user1 = new User({
      username: req.body.username,
      email: req.body.email,
      passhash: req.body.password,
      created_at: new Date(),
      updated_at: new Date(),
      salt: "samplesalt"
    });
    return user1.save(function(err) {
      if (err) {
        res.send(err);
      }
      return res.send("ok");
    });
  };

  signin = function(req, res) {
    return res.render("users/signin", {
      title: "login"
    });
  };

  logon = function(req, res) {
    return User.find({
      username: req.body.username,
      passhash: req.body.password
    }, function(err, user) {
      if (err) {
        res.send("wrong username/password");
      }
      if (user) {
        return res.send("hello " + user);
      }
    });
  };

  exports.signup = signup;

  exports.signin = signin;

  exports.register = register;

  exports.logon = logon;

}).call(this);
