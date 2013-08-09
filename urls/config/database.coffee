mongoose = require "mongoose"
host = process.env.OPENSHIFT_MONGODB_DB_HOST || "localhost"
uri1 = "mongodb://gankgu:Mongopass@#{host}/nag"
uri1 = "mongodb://#{host}/nag" if host is "localhost"
uri2 = "mongodb://gankgu:Mongopass@#{host}/api"
uri2 = "mongodb://#{host}/api" if host is "localhost"
conn1 = mongoose.createConnection uri1
conn2 = mongoose.createConnection uri2

exports.conn1 = conn1
exports.conn2 = conn2

