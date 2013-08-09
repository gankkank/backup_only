(function() {
  module.exports = function(app, store, db) {
    app.post("/signin", function(req, res) {
      var User;

      User = require("../models/user")(db);
      console.log(req.body, req.cookies);
      return User.findOne({
        username: req.body.username,
        passhash: req.body.password
      }, function(err, user) {
        if (err) {
          res.send(err);
        }
        return res.send(user);
      });
    });
    app.get("/signin", function(req, res) {
      console.log(req.body, req.cookies);
      return res.render("users/signin", {
        title: "signin"
      });
    });
    app.get("/sessions", function(req, res) {
      var sid;

      console.log(req.body, req.cookies, req.cookies['sid']);
      sid = req.cookies['connect.sid'];
      console.log(sid);
      return store.all(function(err, sessions) {
        if (err) {
          res.send(err);
        }
        return res.send(sessions);
      });
    });
    return app.get("/sessions/get", function(req, res) {
      var d;

      console.log(req.sessionID);
      d = new Date;
      console.log(d.toLocaleTimeString());
      return store.get(req.sessionID, function(err, data) {
        var expires;

        if (err) {
          console.log(err);
        }
        data.cookie.count = 1;
        store.set(req.sessionID, data, function(err, result) {
          if (err) {
            console.log(err);
          }
          return console.log(result);
        });
        expires = data.cookie.expires;
        return res.send(expires.toLocaleString());
      });
    });
  };

}).call(this);
