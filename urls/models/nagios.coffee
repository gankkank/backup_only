mongoose = require "mongoose"
Schema = mongoose.Schema
hostSchema = Schema
  name: { type: String, unique: true }
  description: String
  ip: String
  group: { type: Number, ref: "Group" }

groupSchema = Schema
  _id: Number
  name: { type: String, unique: true }
  description: String
  hosts: [{type: Schema.Types.ObjectId, ref: "Host" }]

serviceSchema = mongoose.Schema
  name: { type: String, unique: true }
  description: String
  command: String
  type: String

exports.Host = (conn) ->
  ( conn || mongoose).model "Host", hostSchema
exports.Group = (conn) ->
  ( conn || mongoose).model "Group", groupSchema
exports.Service = (conn) ->
  ( conn || mongoose).model "Service", serviceSchema
