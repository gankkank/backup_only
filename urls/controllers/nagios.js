(function() {
  var Group, Host, Search, Service, db, query;

  db = require("../config/database").conn1;

  Host = require("../models/nagios").Host(db);

  Group = require("../models/nagios").Group(db);

  Service = require("../models/nagios").Service(db);

  query = function(model, queries, callback) {
    switch (model) {
      case "hosts":
        return Host.find(queries, function(err, items) {
          if (err) {
            callback(err);
          }
          if (!err) {
            return callback(items);
          }
        });
      case "groups":
        return Group.find(queries, function(err, items) {
          if (err) {
            callback(err);
          }
          if (!err) {
            return callback(items);
          }
        });
      case "services":
        return Service.find(queries, function(err, items) {
          if (err) {
            callback(err);
          }
          if (!err) {
            return callback(items);
          }
        });
    }
  };

  Search = (function() {
    function Search() {}

    Search.prototype.type = function(req, res) {
      return query(req.params.type, req.query, function(result) {
        return res.send(result);
      });
    };

    return Search;

  })();

  exports.search = new Search;

}).call(this);
