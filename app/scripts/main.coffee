'use strict'

Client = require 'babascript-client'
Backbone = require 'backbone'
Backbone.$ = $ = require '../../bower_components/jquery/dist/jquery'

app = require './app'
Router = require './router'
Controller = require './controller'
Views = require './views'
Model = require './model'

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

  app.client = new Client "takumibaba"
  app.client.on "get_task", (task) ->
    console.log task
    app.task = new Model.Task
      key: task.key
      format: task.format || 'boolean'
      description: task.description
      list: task.list || []
    path = "/#{app.client.name}/#{task.format}"
    app.router.navigate path, true
  app.client.on "cancel_task", ->
    path = "/#{app.client.name}"
    app.router.navigate path, true

  Backbone.history.start()
  app.router.navigate "/", true

app.start()