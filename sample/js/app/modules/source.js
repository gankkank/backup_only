// Generated by CoffeeScript 1.6.2
(function() {
  define(["app"], function(app) {
    var Source;

    Source = app.module();
    Source.Model = Backbone.Model.extend();
    Source.Collection = Backbone.Collection.extend({
      model: Source.Model,
      url: '/v1/sources'
    });
    Source.Router = Backbone.Router.extend();
    Source.Views.Item = Backbone.View.extend({
      template: "source_item",
      tagName: "li",
      initialize: function() {},
      serialize: function() {
        return this.model.toJSON();
      }
    });
    Source.Views.List = Backbone.View.extend({
      template: "source_list",
      initialize: function() {
        this.collection = new Source.Collection();
        this.collection.fetch({
          reset: true
        });
        return this.listenTo(this.collection, 'reset', this.render);
      },
      beforeRender: function() {
        console.log("before rendering: " + (JSON.stringify(this.collection)));
        return this.collection.each(function(c) {
          return this.insertView("ul", new Source.Views.Item({
            model: c
          }));
        }, this);
      }
    });
    return Source;
  });

}).call(this);