
db = require("../config/database").conn1

Host = require("../models/nagios").Host(db)
Group = require("../models/nagios").Group(db)
Service = require("../models/nagios").Service(db)

query = (model,queries,callback) ->
  switch model
    when "hosts" then Host.find queries, (err, items) ->
      #db.close()
      callback err if err
      callback items if ! err
    when "groups" then Group.find queries, (err, items) ->
      #db.close()
      callback err if err
      callback items if ! err
    when "services" then Service.find queries, (err, items) ->
      #db.close()
      callback err if err
      callback items if ! err

class Search
  type: (req, res) ->
    query req.params.type, req.query, (result) -> res.send result

exports.search = new Search
