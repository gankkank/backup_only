(function() {
  var User, db;

  db = require("../config/database").conn2;

  User = require("../models/user").User(db);

  module.exports = function(store, app) {
    app.post("/signin", function(req, res) {
      return User.find({
        username: req.body.username,
        passhash: req.body.password
      }, function(err, user) {
        var collection, session;

        if (err) {
          console.log(err);
        }
        if (user.length === 0) {
          return res.send("wrong username/password");
        } else {
          collection = db.model("mysessions");
          session = new collection({
            sid: req.cookies["connect.sid"]
          });
          return session.save(function(err) {
            return store.set(req.cookies["connect.sid"], function(err, result) {
              console.log(result);
              return res.send("hello " + session.data.username);
            });
          });
        }
      });
    });
    app.get("/signout", function(req, res) {
      return store.destroy({
        sid: req.cookies["connect.sid"]
      }, function(err, result) {
        console.log(result);
        return res.send("ok");
      });
    });
    return app.get("/sessions", function(req, res) {
      return store.all(function(err, sessions) {
        return res.send(sessions);
      });
    });
  };

}).call(this);
