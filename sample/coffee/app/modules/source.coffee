#define [
#         "app"
#       ],
#       (app) ->
define [ "app" ], (app) ->
  Source = app.module()
  Source.Model = Backbone.Model.extend()

  Source.Collection = Backbone.Collection.extend
    model: Source.Model
    url: '/v1/sources'

  Source.Router = Backbone.Router.extend()
      
  Source.Views.Item = Backbone.View.extend
    template: "source_item"
    tagName: "li"
    initialize: () ->
      #console.log @model.get("name")
    serialize: ->
      @model.toJSON()
    #  {
    #    name: @model.get("name"),
    #    version: @model.get("version"),
    #    url: @model.get("url")
    #  }
  Source.Views.List = Backbone.View.extend
    template: "source_list"
    #tagName: "ul"
    #el: "#sources"
    initialize: () ->
      @collection = new Source.Collection()
      @collection.fetch({reset: true})
      @listenTo @collection, 'reset', @render
      #col = new Source.Collection()
      #col.fetch
      #  success: (col, res) ->
      #    console.log "col: #{JSON.stringify(col)}"
      #    console.log "res: #{JSON.stringify(res)}"
      #    @collection = col
    #  console.log @collection
    #serialize: ->
    #  collection: collection
    beforeRender: () ->
      console.log "before rendering: #{JSON.stringify(@collection)}"
      @collection.each (c) ->
        this.insertView "ul", new Source.Views.Item({model: c})
      , this
      #manage(this).render()

  Source
