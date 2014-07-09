not (name, definition) ->
  unless typeof module is "undefined"
    module.exports = definition()
  else if typeof define is "function" and typeof define.amd is "object"
    define definition
  else
    this[name] = definition()
("Phonebook", ->
  Phonebook = (options) ->
    @url = options.url or ""
    @options = options.options or {}
    @data = options.data or {}
    @parent = options.parent or null
  Phonebook:: =
    define: (object) ->
      key = object.name
      url = object.url
      method = object.type
      data = object.data
      options = object.options
      allowed = undefined
      if allowed = not this[key]
        this[key] = (_data, _options) ->
          @request method, url, jQuery.extend(data, _data), jQuery.extend(options, _options)
      allowed

    request: (method, url, data, options) ->
      data = data or {}
      options = options or {}
      jQuery.ajax jQuery.extend(@buildHash("options", options),
        url: @getURL() + url
        type: method
        data: @buildHash("data", data)
      )

    getURL: ->
      prefix = ""
      prefix = @parent.getURL()  if @parent
      (prefix + @url).replace /[\/]+/g, "/"

    buildHash: (key, hash) ->
      all = this[key]
      hash = hash.bind(hash)()  if typeof hash is "function"
      all = @parent.buildHash(key, all)  if @parent
      jQuery.extend {}, all, hash

    addChapter: (object) ->
      allowed = undefined
      key = object.name
      if allowed = not this[key]
        this[key] = Phonebook.open(jQuery.extend(object,
          parent: this
        ))
      allowed

    get: (url, data, options) ->
      @request "GET", url, data, options

    post: (url, data, options) ->
      @request "POST", url, data, options

    put: (url, data, options) ->
      @request "PUT", url, data, options

    destroy: (url, data, options) ->
      @request "DELETE", url, data, options

  Phonebook.open = (options) ->
    new Phonebook(options)

  Phonebook.version = "1.0"
  Phonebook
)
