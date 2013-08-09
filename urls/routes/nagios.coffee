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

module.exports = (app) ->
  app.get "/nagios/index", (req, res) ->
    mongoose.connect "#{uri}"
    db = mongoose.connection
    Group.find {}, (err, items) ->
      i=1
      hostList = () ->
        data = for hostID in item.hosts
          Host.findById hostID, (err, host) ->
            console.log "#{i},#{host.hostname},#{host.description}"
      for item in items
        #console.log item
        groupList = "##{item.groupname},#{item.description}\n#{hostList().toString()}"
        i++
        #console.log groupList
      db.close()
    res.send "ok"
