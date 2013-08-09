(function() {
  var host, mongoose, uri, urls, urlsSchema;

  mongoose = require("mongoose");

  urlsSchema = mongoose.Schema({
    service: {
      type: String
    },
    version: {
      type: String,
      unique: true
    },
    url: {
      type: String,
      unique: true
    }
  });

  urls = mongoose.model("urls", urlsSchema);

  host = process.env.OPENSHIFT_MONGODB_DB_HOST || "localhost";

  uri = "mongodb://gankgu:Mongopass@" + host + "/api";

  if (host === "localhost") {
    uri = "mongodb://" + host + "/api";
  }

  Array.prototype.unique = function() {
    var key, output, value, _i, _ref, _results;
    output = {};
    for (key = _i = 0, _ref = this.length; 0 <= _ref ? _i < _ref : _i > _ref; key = 0 <= _ref ? ++_i : --_i) {
      output[this[key]] = this[key];
    }
    _results = [];
    for (key in output) {
      value = output[key];
      _results.push(value);
    }
    return _results;
  };

  module.exports = function(app) {
    app.get("/urls/new", function(req, res) {
      return res.render("urls/new", {
        title: "service urls"
      });
    });
    app.post("/urls/new", function(req, res) {
      var postData, url;
      url = req.body;
      console.log(req.body);
      postData = new urls({
        service: url.service.trim(),
        version: url.version.trim(),
        url: url.url.trim()
      });
      postData.save(function(err) {
        return res.send(err);
      });
      return res.send("added");
    });
    app.get("/urls/search", function(req, res) {
      var db;
      mongoose.connect("" + uri);
      db = mongoose.connection;
      return urls.find({}, function(err, items) {
        var data;
        if (err) {
          res.send(err);
        }
        data = function() {
          var item, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = items.length; _i < _len; _i++) {
            item = items[_i];
            _results.push(item.service);
          }
          return _results;
        };
        db.close();
        return res.send(data().unique());
      });
    });
    app.get("/urls/search/:service", function(req, res) {
      var db;
      mongoose.connect("" + uri);
      db = mongoose.connection;
      return urls.find({
        service: req.params.service
      }, function(err, items) {
        var data;
        if (err) {
          res.send(err);
        }
        data = function() {
          var item, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = items.length; _i < _len; _i++) {
            item = items[_i];
            _results.push(item.version);
          }
          return _results;
        };
        db.close();
        return res.send(data().unique());
      });
    });
    app.get("/urls/search/:service/:version", function(req, res) {
      var db;
      mongoose.connect("" + uri);
      db = mongoose.connection;
      return urls.find({
        service: req.params.service,
        version: req.params.version
      }, function(err, items) {
        var data;
        if (err) {
          res.send(err);
        }
        data = function() {
          var item, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = items.length; _i < _len; _i++) {
            item = items[_i];
            _results.push(item.url);
          }
          return _results;
        };
        db.close();
        return res.send(data().unique());
      });
    });
    app.get("/urls", function(req, res) {
      var db;
      mongoose.connect("" + uri);
      db = mongoose.connection;
      return urls.find({}, function(err, items) {
        if (err) {
          res.send(err);
        }
        db.close();
        return res.render("urls/index", {
          title: "urls index",
          data: items
        });
      });
    });
    app.get("/urls/:id/edit", function(req, res) {
      var db;
      mongoose.connect("" + uri);
      db = mongoose.connection;
      return urls.findById(req.params.id, function(err, item) {
        if (err) {
          res.send(err);
        }
        db.close();
        return res.render("urls/edit", {
          title: "urls edit",
          data: item
        });
      });
    });
    return app.post("/urls/:id", function(req, res) {
      var db;
      mongoose.connect("" + uri);
      db = mongoose.connection;
      return urls.findById(req.params.id, function(err, url) {
        url.service = req.body.service;
        url.version = req.body.version;
        url.url = req.body.url;
        url.save(function(err) {
          if (err) {
            res.send(err);
          }
          return db.close();
        });
        return res.send("updated");
      });
    });
  };

}).call(this);
