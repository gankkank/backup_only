mongoose = require "mongoose"
HostSchema = mongoose.Schema
  hostname: { type: String, unique: true }
  ip: String
  description: String
  services: Array
GroupSchema = mongoose.Schema
  groupname: { type: String, unique: true }
  description: String
  hosts: Array

Host = mongoose.model "Host", HostSchema
Group = mongoose.model "Group", GroupSchema

host = process.env.OPENSHIFT_MONGODB_DB_HOST || "localhost"
uri = "mongodb://gankgu:Mongopass@#{host}/api"
uri = "mongodb://#{host}/nag" if host is "localhost"

mongoose.connect "#{uri}"
db = mongoose.connection

Group.find {}, (err, items) ->
  for item in items
    for hostid in item.hosts
      getData = (callback) ->
        Host.findById hostid, (err, host) ->
          data = host.hostname
          callback(data)
      getData (get)  -> console.log get
    #console.log data
