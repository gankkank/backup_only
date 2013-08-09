mongoose = require "mongoose"
#urlsSchema = mongoose.Schema
#  service: { type: String }
#  version: { type: String, unique: true }
#  url: { type: String, unique: true }
#urls = mongoose.model "urls", urlsSchema
#mongoose.connection.on "error", () ->
#though I choose not to display err, there will still have one: trying to open unclosed connection mongoose [err]
host = process.env.OPENSHIFT_MONGODB_DB_HOST || "localhost"
#uri = "mongodb://gankgu:Mongopass@#{host}/nag"
uri = "mongodb://#{host}/nag" if host is "localhost"
mongoose.connect "#{uri}"
db = mongoose.connection
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

host1 = new Host
host1.hostname = "api.c1.rhc.gankkank.com"
host1.ip = "127.0.0.1"
host1.description = "api cloud #1"
host1.services = [ "ssh","mysql","web","ftp","nodejs"]

host2 = new Host
host2.hostname= "api.c2.rhc.gankkank.com"
host2.ip= "127.0.0.1"
host2.description= "api cloud #2"
host2.services= [ "ssh","mysql","web","ftp","nodejs"]

group1 = new Group
group1.groupname= "api"
group1.description= "api host group"
group1.hosts = [ host1._id, host2._id]
#group1.hosts= [
#    "api.c1.rhc.gankkank.com"
#    "api.c2.rhc.gankkank.com"
#  ]

#console.log host1, host2, group1
host1.save (err) -> console.log err
host2.save (err) -> console.log err
group1.save (err) -> console.log err

Host.find {}, (err, items) ->
  console.log items
Group.find {}, (err, items) ->
  console.log items
