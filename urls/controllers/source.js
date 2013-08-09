(function() {
  var Search, Source, db, query;

  db = require("../config/database").conn2;

  Source = require("../models/source").Source(db);

  query = function(service, queries, callback) {
    if (service) {
      queries.service = service;
    }
    return Source.find(queries, function(err, items) {
      if (err) {
        callback(err);
      }
      if (!err) {
        return callback(items);
      }
    });
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
