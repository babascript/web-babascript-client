'use strict'

Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

app = new Marionette.Application()

app.addRegions
  'header': '#header'
  'main': '#main'
  'settings': '#settings'
  'login': '#login'
  'error': '#error'

console.log app

app.API = 'http://linda.babascript.org'

module.exports = app