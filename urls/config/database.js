(function() {
  var conn1, conn2, host, mongoose, uri1, uri2;

  mongoose = require("mongoose");

  host = process.env.OPENSHIFT_MONGODB_DB_HOST || "localhost";

  uri1 = "mongodb://gankgu:Mongopass@" + host + "/nag";

  if (host === "localhost") {
    uri1 = "mongodb://" + host + "/nag";
  }

  uri2 = "mongodb://gankgu:Mongopass@" + host + "/api";

  if (host === "localhost") {
    uri2 = "mongodb://" + host + "/api";
  }

  conn1 = mongoose.createConnection(uri1);

  conn2 = mongoose.createConnection(uri2);

  exports.conn1 = conn1;

  exports.conn2 = conn2;

}).call(this);
