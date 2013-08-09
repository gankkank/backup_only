(function() {
  var app;

  $("#datepicker").datepicker({
    format: "yyyy-mm-dd"
  }).on('changeDate', function(ev) {
    return $(this).datepicker('hide');
  });
  $("#datepicker1").datepicker({
    format: "yyyy-mm-dd"
  }).on('changeDate', function(ev) {
    return $(this).datepicker('hide');
  });

  app = {};

  app.TodoView = Backbone.View.extend({
    tagName: 'p',
    template: _.template($('#item-template').html()),
    render: function(option) {
      this.$el.html(this.template({
        type: option
      }));
      return this;
    }
  });

  app.AppView = Backbone.View.extend({
    el: '#device-container',
    initialize: function() {},
    events: {
      'click #selectlist': 'addView'
    },
    addView: function(e) {
      var type, view;
      view = new app.TodoView();
      type = $(e.target).html();
      return $('#url-list').append(view.render(type).el);
    }
  });

  app.appView = new app.AppView();

}).call(this);

