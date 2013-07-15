mongoose = require "mongoose"
host = process.env.OPENSHIFT_MONGODB_DB_HOST or "localhost"
dbname="dev"
uri = "mongodb://#{host}/#{dbname}" if host is "localhost"
#uri = ..
conn1 = mongoose.createConnection uri
exports.conn1 = conn1
