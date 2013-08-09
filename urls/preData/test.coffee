###
func1 = () ->
  call: () -> console.log "ok"
  bye: -> console.log "bye"
func1.call()
###
mongoose = require "mongoose"

host = process.env.OPENSHIFT_MONGODB_DB_HOST || "localhost"
auth = "gankgu:Mongopass"
if host is "localhost"
  mongoose.connect "mongodb://#{host}/nag"
else
  mongoose.connect "mongodb://#{auth}@#{host}/nag"
db = mongoose.connection

Host = require("../models/host.coffee").Host
Group = require("../models/host.coffee").Group
i = 1
data1 = new Host
  name: "api.c1.rhcloud.gankkank.com", description: "this is #1", ip: "127.0.0.1"
data2 = new Host
  name: "api.c2.rhcloud.gankkank.com", description: "this is #2", ip: "127.0.0.1"
group = new Group
  _id: 0, name: "api", description: "api cloud servers", hosts: [ data2, data1 ]
group.save (err) ->
  data1.group = group._id
  data2.group = group._id
  data1.save (err) -> console.log err if err
  data2.save (err) -> console.log err if err
  console.log err if err
