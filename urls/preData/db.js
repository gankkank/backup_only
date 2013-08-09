(function() {
  var auth, data, data1, data2, data3, data4, db, host, mongoose, urls, urlsSchema;

  mongoose = require("mongoose");

  host = process.env.OPENSHIFT_MONGODB_DB_HOST || "localhost";

  auth = "gankgu:Mongopass";

  if (host === "localhost") {
    mongoose.connect("mongodb://" + host + "/api");
  } else {
    mongoose.connect("mongodb://" + auth + "@" + host + "/api");
  }

  db = mongoose.connection;

  urlsSchema = mongoose.Schema({
    service: String,
    version: String,
    url: String
  });

  urls = mongoose.model("urls", urlsSchema);

  data1 = new urls({
    service: "node",
    version: "0.10.0",
    url: "http://node.js...."
  });

  data2 = new urls({
    service: "node",
    version: "0.6.20",
    url: "http://nodejs.org/dist/v0.6.20/node-v0.6.20.tar.gz"
  });

  data3 = new urls({
    service: "httpd",
    version: "2.2.24",
    url: "http://apache.communilink.net//httpd/httpd-2.2.24.tar.gz"
  });

  data4 = new urls({
    service: "httpd",
    version: "2.4.4",
    url: "http://apache.communilink.net//httpd/httpd-2.4.4.tar.gz"
  });

  data2.save(function(err) {
    return console.log(err);
  });

  data3.save(function(err) {
    return console.log(err);
  });

  data4.save(function(err) {
    return console.log(err);
  });

  data = function() {
    return urls.find({}, function(err, items) {
      var it, _i, _len;
      for (_i = 0, _len = items.length; _i < _len; _i++) {
        it = items[_i];
        it;
      }
      return db.close();
    });
  };

  console.log(data);

}).call(this);
