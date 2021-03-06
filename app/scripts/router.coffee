'use strict'

app = require './app'
Marionette = require 'backbone.marionette'

class Router extends Marionette.AppRouter
  appRoutes:
    "": "to"
    "settings": "settings"
    ":tuplespace": "to"
    ":tuplespace/": "top"
    ":tuplespace/cancel": "cancel"
    ":tuplespace/:view": "client"

module.exports = Router