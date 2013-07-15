module.exports = (db) ->
  Source = require("../models/source")(db)
  sc = ->
  sc::index = (req, res) ->
    Source.find {}, (err, items) ->
      if err then res.send "err";return
      res.send items

  sc::create = (req, res) ->
    post =
      name: req.body.name
      version: req.body.version
      url: req.body.url
    s = new Source(post)
    s.save (err) ->
      if err then res.send "err"; return
      res.send "ok"

  new sc
