mongoose = require("mongoose")
sessionSchema = mongoose.Schema
  sid: { type: String, required: true, unique: true }
  data: {}
  lastAccess: { type Date, index: true }
  expires: { type: Date, index: true }

defaultOptions =
  conn: mongoose.connection
  sessionCollect: "session"
  clear_interval: -1

module.exports = (express) ->
  class MongooseStore
    constructor: (options, cb) ->
      conn = options.conn or defaultOptions.conn
      sessionCollect = options.sessionCollect or defaultOptions.sessionCollect
      clear_interval = options.clear_interval or defaultOptions.clear_interval
      options = options or {}

      #
      Store.call this, options
      @collection = conn.model(sessionCollect)
      @_getCollection = (cb) -> cb and cb(@collection)
      if clear_interval > 0
        @clear_interval = setInterval( ->
          @collection.remove expires: $lt: new Date(), (err) ->
            console.log "Clear sessions: ", err if err
          , clear_interval * 1000, @)

    Store = express.session.Store
    MongooseStore:: = new Store()
    get: (sid, cb) ->
      @_getCollection (collection) ->
        collection.findOne sid: sid, (err, session) ->
          try
            if err
             cb err, null
            else
             if session
               if not session.expires or new Date < session.expires
                 cb null, session.data
               else
                 @destroy sid, cb
             else
               cb()
           catch err
             cb err

    set: (sid, data, cb) ->
      @_getCollection (collection) ->
        try
          lastAccess = new Date()
          expires = lastAccess.setDate(lastAccess.getDate() + 1)
          expires = data.cookie._expires  unless typeof data.cookie is "undefined"
          lastAccess = new Date(data.lastAccess)  unless typeof data.lastAccess is "undefined"
          collection.update sid: sid, { data: data, lastAccess: lastAccess, expires: expires}, upsert: true, cb
        catch err
           cb and cb(err)

    destroy: (sid, cb) ->
      @_getCollection (collection) ->
        collection.remove sid: sid, cb

    all: (cb) ->
      @_getCollection (collection) ->
        collection.find {}, (err, sessions) ->
          if err
            cb and cb(err)
          else
            cb and cb(null, sessions)

    lenght: (cb) ->
      @_getCollection (collection) ->
        collection.count {}, (err, count) ->
          if err
            cb and cb(err)
          else
            cb and cb(null, count)

    clear: (cb) ->
      @_getCollection (collection) ->
        collection.drop -> cb and cb()

  MongooseStore
