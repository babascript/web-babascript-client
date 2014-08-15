'use strict'

Client = require 'babascript-client'
Backbone = require 'backbone'

app = require './app'
Router = require './router'
Controller = require './controller'
Views = require './views'

app.router = new Router
  controller: new Controller()

app.addInitializer ->
  app.header.reset()
  app.main.reset()
  app.settings.reset()
  app.login.reset()
  app.error.reset()

  header = new Views.Header()
  app.header.show header

  app.task = null
  main = new Views.Main
    model: app.task
  app.main.show main

  app.client = new Client("baba")

  Backbone.history.start()

console.log 'main!'

app.start()