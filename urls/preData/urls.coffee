mongoose = require "mongoose"
urlsSchema = mongoose.Schema
  service: { type: String }
  version: { type: String, unique: true }
  url: { type: String, unique: true }
urls = mongoose.model "urls", urlsSchema
#mongoose.connection.on "error", () ->
#though I choose not to display err, there will still have one: trying to open unclosed connection mongoose [err]
host = process.env.OPENSHIFT_MONGODB_DB_HOST || "localhost"
uri = "mongodb://gankgu:Mongopass@#{host}/api"
uri = "mongodb://#{host}/api" if host is "localhost"
Array::unique = ->
  output={}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

module.exports = (app) ->
    app.get "/urls/new", (req, res) ->
      res.render "urls/new", { title: "service urls"}
    app.post "/urls/new", (req, res) ->
      url = req.body
      console.log req.body
      postData = new urls( service: url.service.trim(), version: url.version.trim(), url: url.url.trim())
      postData.save (err) -> res.send err
      res.send "added"

    app.get "/urls/search", (req, res) ->
      #mongoose.connect "mongodb://gankgu:Mongopass@#{host}/api"
      mongoose.connect "#{uri}"
      db = mongoose.connection
      urls.find {}, (err, items) ->
        res.send err if err
        data = ->
          item.service for item in items
        db.close()
        res.send data().unique()

    app.get "/urls/search/:service", (req, res) ->
      #mongoose.connect "mongodb://#{host}/api"
      mongoose.connect "#{uri}"
      db = mongoose.connection
      #console.log req.params.service
      urls.find { service: req.params.service}, (err, items) ->
        res.send err if err
        data = ->
          item.version for item in items
        db.close()
        res.send data().unique()

    app.get "/urls/search/:service/:version", (req, res) ->
      #mongoose.connect "mongodb://#{host}/api"
      mongoose.connect "#{uri}"
      db = mongoose.connection
      #console.log req.params.service
      urls.find { service: req.params.service, version: req.params.version}, (err, items) ->
        res.send err if err
        data = ->
          item.url for item in items
        db.close()
        res.send data().unique()

    app.get "/urls", (req, res) ->
      mongoose.connect "#{uri}"
      db = mongoose.connection
      urls.find {}, (err, items) ->
        res.send err if err
        db.close()
        res.render "urls/index", { title: "urls index", data: items }
    app.get "/urls/:id/edit", (req, res) ->
      mongoose.connect "#{uri}"
      db = mongoose.connection
      urls.findById req.params.id, (err, item) ->
        res.send err if err
        db.close()
        #console.log item
        res.render "urls/edit", { title: "urls edit", data: item}
    app.post "/urls/:id", (req, res) ->
      mongoose.connect "#{uri}"
      db = mongoose.connection
      urls.findById req.params.id, (err, url) ->
        url.service = req.body.service
        url.version = req.body.version
        url.url = req.body.url
        url.save (err) ->
          res.send err if err
          db.close()
        res.send "updated"
