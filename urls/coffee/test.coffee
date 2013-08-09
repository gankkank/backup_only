#items = [ { service: "node"}, {service: "httpd"} ]
#data = ->
# item for item in items
#console.log data()

mongoose = require "mongoose"
urlsSchema = mongoose.Schema
  service: String
  version: { type: String, unique: true }
  url: { type: String, unique: true }
urls = mongoose.model "urls", urlsSchema

uri = "mongodb://127.4.105.129:27017/api"

mongoose.connect "#{uri}"
db = mongoose.connection
#db.auth("admin","CREFTEeh_ygk")
urls.find {}, (err, items) ->
  data = ->
    item.version for item in items
  console.log data()
  db.close()

