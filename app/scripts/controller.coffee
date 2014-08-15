'use strict'

app = require './app'
View = require './views'
Marionette = require 'backbone.marionette'

class Controller extends Marionette.Controller

  to: (tuplespace)->
    username = window.localStorage.getItem("username")
    app.router.navigate "/#{username}/", true

  top: (tuplespace)->
    app.main.currentView.changeView()

  client: (tuplespace, viewname)->
    if !app.task?
      return app.router.navigate "/#{tuplespace}/", true
    app.main.currentView.changeView app.task

  settings: ->

  login: ->
    app.login.show new Views.Login()

  cancel: ->
    console.log 'cancel'
    app.main.close()
    app.main.shpw new Views.ThrowErrorView()

module.exports = Controller