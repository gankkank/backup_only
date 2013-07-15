#define [
#         "app"
#       ],
#       (app) ->
define [ "app" ], (app) ->
  Home = app.module()
  Home.Model = Backbone.Model.extend()

  Home.Collection = Backbone.Collection.extend
    model: Home.Model

  Home.Router = Backbone.Router.extend()
      
  Home.Views.Item = Backbone.View.extend
    template: "home_item"
    tagName: "li"
    serialize: ->
      name: @model.get("name")
  Home.Views.Tutorial = Backbone.View.extend
    template: "home"
    initialize: (init) ->
      @collection = new Home.Collection(init)
    beforeRender: ->
      @collection.each (c) ->
        @insertView "ul", new Home.Views.Item({ model: c})
      , this

  Home
