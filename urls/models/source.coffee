mongoose = require "mongoose"

sourceSchema = mongoose.Schema
  service: { type: String }
  version: { type: String, unique: true }
  url: { type: String, unique: true }

exports.source = (conn) ->
  ( conn || mongoose).model "source", sourceSchema
