mongoose = require "mongoose"
host = process.env.OPENSHIFT_MONGODB_DB_HOST || "localhost"
uri2 = "mongodb://gankgu:Mongopass@#{host}/api"
uri2 = "mongodb://#{host}/api" if host is "localhost"
Source = require("../models/source.coffee").source
mongoose.connect uri2
db = mongoose.connection
data1 = new Source
  service: "node", version: "0.10.0", url: "http://node.js...."
data2 = new Source
  service: "node", version: "0.6.20", url: "http://nodejs.org/dist/v0.6.20/node-v0.6.20.tar.gz"
data3 = new Source
  service: "httpd", version: "2.2.24", url: "http://apache.communilink.net//httpd/httpd-2.2.24.tar.gz"
data4 = new Source
  service: "httpd", version: "2.4.4", url: "http://apache.communilink.net//httpd/httpd-2.4.4.tar.gz"

data1.save (err) ->
  console.log err
data2.save (err) -> console.log err
data3.save (err) -> console.log err
data4.save (err) -> console.log err
