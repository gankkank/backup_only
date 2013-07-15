define [
  "app",
  "modules/home",
  "modules/source"
], (app, Home, Source) ->
  Router = Backbone.Router.extend(
    routes:
      "source": "source"
      "": "index"
    index: (hash) ->
      console.log 'index of home'
      fields = [
        { name: "source" }
        { name: "files" }
      ]
      app.useLayout('main').setViews
        '.tutorial': new Home.Views.Tutorial(fields)
      .render()

    source: () ->
      collection= [
        { name: "nginx", version: "1.2.4", url: "http://nginx-1.2.4" }
        { name: "nginx", version: "1.3.4", url: "http://nginx-1.3.4" }
        { name: "httpd", version: "1.2.4", url: "http://httpd-1.2.4" }
      ]
      console.log 'index of source'
      #col = new Source.Collection()
      #console.log col
      app.useLayout('main').setViews
        '.tutorial': new Source.Views.List()
      #.render()
      #col.fetch()
  )

  Router
