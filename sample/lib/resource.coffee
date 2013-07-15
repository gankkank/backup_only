###
#@created       2013-06-05 14:45
#@package       resource
#@copyright     Copyright (c) 2012-2013 - All rights reserved.
#@license       MIT License
#@author        Gankkank <gankkank@gmail.com>
#@link          https://github.com/gankkank/express
###


module.exports = (app, db) ->

  auth = (req, res, next) ->
    if req.session.username?
      next()
    else
      console.log req.sessionID
      next()
      #res.redirect "/signin"

  loadroute = (v, n, id="id", parent) ->
    if parent then cn="#{parent}_#{n}" else cn=n
    obj = require("../#{v}/controllers/#{cn}")(db)
    for key, value of obj
      if parent then path="/#{v}/#{parent}/:id/#{n}" else path="/#{v}/#{n}"
      onePath="#{path}/:#{id}"
      switch key
        when "index" then app.get path, auth, value
        when "create" then app.post path, auth, value
        when "show" then app.get onePath, auth, value
        when "update" then app.put onePath, auth, value
        when "destroy" then app.del onePath, auth, value
  
  resource = (version, name, conf) ->
      loadroute(version, name)
      if ! conf then return
      for key, value of conf
        loadroute version, key, value, name
  
  resource
