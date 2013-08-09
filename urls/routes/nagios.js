(function() {
  var Group, GroupSchema, Host, HostSchema, host, mongoose, uri;

  mongoose = require("mongoose");

  HostSchema = mongoose.Schema({
    hostname: {
      type: String,
      unique: true
    },
    ip: String,
    description: String,
    services: Array
  });

  GroupSchema = mongoose.Schema({
    groupname: {
      type: String,
      unique: true
    },
    description: String,
    hosts: Array
  });

  Host = mongoose.model("Host", HostSchema);

  Group = mongoose.model("Group", GroupSchema);

  host = process.env.OPENSHIFT_MONGODB_DB_HOST || "localhost";

  uri = "mongodb://gankgu:Mongopass@" + host + "/api";

  if (host === "localhost") {
    uri = "mongodb://" + host + "/nag";
  }

  module.exports = function(app) {
    return app.get("/nagios/index", function(req, res) {
      var db;

      mongoose.connect("" + uri);
      db = mongoose.connection;
      Group.find({}, function(err, items) {
        var groupList, hostList, i, item, _i, _len;

        i = 1;
        hostList = function() {
          var data, hostID;

          return data = (function() {
            var _i, _len, _ref, _results;

            _ref = item.hosts;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              hostID = _ref[_i];
              _results.push(Host.findById(hostID, function(err, host) {
                return console.log("" + i + "," + host.hostname + "," + host.description);
              }));
            }
            return _results;
          })();
        };
        for (_i = 0, _len = items.length; _i < _len; _i++) {
          item = items[_i];
          groupList = "#" + item.groupname + "," + item.description + "\n" + (hostList().toString());
          i++;
        }
        return db.close();
      });
      return res.send("ok");
    });
  };

}).call(this);
