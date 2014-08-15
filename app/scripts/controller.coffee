'use strict'

app = require './app'
View = require './views'
Marionette = require 'backbone.marionette'

class Controller extends Marionette.Controller

  to: (tuplespace)->
    app.router.navigate "/#{app.client.name}/", true

  top: (tuplespace)->
    app.main.currentView.changeView()

  client: (tuplespace, viewname)->
    if !app.task?
      return app.router.navigate "/#{tuplespace}/", true
    app.main.currentView.changeView app.task

  settings: ->

  cancel: ->
    console.log 'cancel'
    app.main.close()
    app.main.shpw new Views.ThrowErrorView()

module.exports = Controller