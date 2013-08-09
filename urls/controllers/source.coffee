#mongoose = require "mongoose"
#host = process.env.OPENSHIFT_MONGODB_DB_HOST || "localhost"
#uri2 = "mongodb://gankgu:Mongopass@#{host}/api"
#uri2 = "mongodb://#{host}/api" if host is "localhost"
db = require("../config/database").conn2
Source = require("../models/source").Source(db)


query = (service,queries,callback) ->
  queries.service = service if service
  Source.find queries, (err, items) ->
    callback err if err
    callback items if ! err

class Search
  type: (req, res) ->
    query req.params.type, req.query, (result) -> res.send result

exports.search = new Search
