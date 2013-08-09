mongoose = require "mongoose"

host = process.env.OPENSHIFT_MONGODB_DB_HOST || "localhost"
auth = "gankgu:Mongopass"
if host is "localhost"
  mongoose.connect "mongodb://#{host}/nag"
else
  mongoose.connect "mongodb://#{auth}@#{host}/nag"


db = mongoose.connection

###
urlsSchema = mongoose.Schema
  service: String
  version: String
  url: String

urls = mongoose.model "urls", urlsSchema

data1 = new urls
  service: "node", version: "0.10.0", url: "http://node.js...."
data2 = new urls
  service: "node", version: "0.6.20", url: "http://nodejs.org/dist/v0.6.20/node-v0.6.20.tar.gz"
data3 = new urls
  service: "httpd", version: "2.2.24", url: "http://apache.communilink.net//httpd/httpd-2.2.24.tar.gz"
data4 = new urls
  service: "httpd", version: "2.4.4", url: "http://apache.communilink.net//httpd/httpd-2.4.4.tar.gz"
data1.save (err) ->
  console.log err
data2.save (err) -> console.log err
data3.save (err) -> console.log err
data4.save (err) -> console.log err

data = ->
  urls.find {}, (err, items) ->
    it for it in items
    db.close()
console.log data
###

hostSchema = mongoose.Schema
  name: { type: String, unique: true }
  description: String
  ip: String

Host = mongoose.model "Host", hostSchema
data1 = new Host
  name: "api.c2.rhcloud.gankkank.com", description: "this is #2", ip: "127.0.0.1"
data1.save (err) -> console.log err
Host.find {}, (err, items) ->
  console.log items
  db.close()
