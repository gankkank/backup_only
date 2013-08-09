mongoose = require "mongoose"

userSchema = mongoose.Schema
  username: { type: String, unique: true }
  email: { type: String, unique: true }
  created_at: Date
  updated_at: Date
  passhash: String
  salt: String

module.exports = (conn) ->
  ( conn || mongoose).model "User", userSchema
