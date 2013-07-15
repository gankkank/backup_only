mongoose = require "mongoose"

source = mongoose.Schema
  name: { type: String, trim: true, required: true }
  version: { type: String, trim: true, required: true }
  url: { type: String, trim: true, required: true }

module.exports = (conn) ->
  ( conn || mongoose).model "Source", source
