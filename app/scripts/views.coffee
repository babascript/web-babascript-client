'use strict'

Backbone = require 'backbone'
Marionette = require 'backbone.marionette'

app = require './app'
Model = require './model'

class BaseView extends Marionette.ItemView
  tagName: "div"
  events:
    "touchstart button": "active"
    "touchend button": "normal"
    'submit': "submitcancel"

  initialize: ->

  active: (e) ->
    $(e.currentTarget).addClass 'active'
  normal: (e) ->
    $(e.currentTarget).removeClass 'active'

  submitcancel: ->
    return false

  returnValue: (value, option={})->
    app.task = null
    app.client.emit 'cancel_task'
    app.client.returnValue value, option

  cancel: ->
    app.task = null
    app.client.emit 'cancel_task'
    app.client.cancel()

class HeaderView extends Marionette.ItemView
  template: '#header-template'
  className: 'container'
  ui:
    cancel: 'a.cancel-button'
    setting: 'a.settings-button'
    logout: 'a.logout'
    name: 'a.header-title'
  events:
    "click @ui.logout": 'logout'
    'click @ui.cancel': 'cancelTask'
    'click @ui.setting': 'settings'

  initialize: ->

  cancelTask: ->
    # キャンセルビュー出す
    return if !App.task?
    # App.router.navigate "/#{App.username}/cancel"
    app.error.reset()
    app.error.show new ThrowErrorView()

  settings: ->
    app.settings.show new SettingsView()

class SettingsView extends Marionette.ItemView
  template: '#settings-template'
  className: 'modal-dialog'
  ui:
    username: 'input#username'
    update: 'button.update'
    close: 'button.close'
  events:
    "click @ui.update": 'update'
    "click @ui.logout": 'logout'
    "click @ui.close": 'close'
  update: ->
    username = @ui.username.val()
    return if !username? or username.length is 0
    window.localStorage.setItem "username", username
    @$el.modal()
    @logout()
    window.location.reload()
  close: ->
    # require('app').settings.reset()
    # @$el.modal()

class MainView extends Marionette.LayoutView
  template: '#main-template'
  regions:
    returnview: '#returnview'
  initialize: ->

  changeView: (model) ->
    format = model?.get 'format'
    viewClass = switch format
      when "", "index"
        NormalView
      when "boolean", "bool"
        BooleanView
      when "string"
        StringView
      when "list"
        ListView
      when "number", "int"
        NumberView
      when "void"
        VoidView
      when "camera"
        CameraView
      else
        NormalView
    @returnview.reset()
    @returnview.show new viewClass {model: model}

class NormalView extends BaseView
  template: '#normal-template'
  className: 'normal-page'

class BooleanView extends BaseView
  template: '#boolean-template'
  className: 'boolean-page'
  ui:
    truebutton: 'button.true'
    falsebutton: 'button.false'
  events:
    'click @ui.truebutton': 'returntrue'
    'click @ui.falsebutton': 'returnfalse'
  returntrue: ->
    @returnValue true
  returnfalse: ->
    @returnValue false

class StringView extends BaseView
  template: '#string-template'
  className: 'string-page'
  ui:
    input: 'input.string-value'
    button: 'button'
  events:
    'click @ui.button': 'returnString'
  returnString: ->
    @returnValue @ui.input.val()

class ListView extends BaseView
  template: '#list-template'
  className: 'list-page'
  ui:
    select: 'select'
    button: 'button'
  events:
    'click @ui.button': 'returnSelect'
  returnSelect: ->
    value = @ui.select.val()
    console.log value
    @returnValue value

class NumberView extends BaseView
  template: '#number-template'
  className: 'number-page'
  ui:
    input: 'input.number-value'
    button: 'button'
  events:
    'click @ui.button': 'returnNumber'
  returnNumber: ->
    @returnValue @ui.input.val()

class VoidView extends BaseView
  template: '#void-template'
  className: 'void-page'
  ui:
    button: 'button.void'
  events:
    'click @ui.button': 'returnVoid'
  returnVoid: ->
    @returnValue 'true'

class CameraView extends BaseView
  template: '#camera-template'
  className: 'camera-page'
  ui:
    'camera': "input.camera"
  events:
    'change @ui.camera': 'change'
  change: (e) ->
    console.log e
    f = e.target.files[0]
    return if !f? or !f.type.match "image.*"
    reader = new FileReader()
    reader.onload = (e) =>
      @returnValue e.target.result
    reader.readAsBinaryString f


class Task extends Backbone.Model

  initialize: ->
    @$el.html @template()


class ThrowErrorView extends Marionette.ItemView
  template: '#throw-error-template'
  className: 'throw-error-page modal fade'
  style: 'top: 100px'
  ui:
    cancel: 'button.cancel'
    return: 'button.return'
    input: 'input.string-value'
    select: 'select.setphrase'
  events:
    'click @ui.cancel': 'cancel'
    'click @ui.return': 'return'
  initialize: ->
    @model = new Backbone.Model()
    console.log app.task
    key = app.task.get "key"
    @model.set "key", key
    $(@el).css 'top', '30px'
  onRender: ->
    $(@el).modal('show')

  onBeforeDestroy: ->
    $(".throw-error-page").modal "hide"

  cancel: ->
    if @ui.input.val() isnt ""
      cause = @ui.input.val()
    else
      cause = @ui.select.val()
    app.task = null
    app.client.emit 'cancel_task'
    app.client.cancel cause
    app.error.reset()

  return: ->
    app.error.reset()

module.exports =
  Header: HeaderView
  Base: BaseView
  Main: MainView
  Normal: NormalView
  Boolean: BooleanView
  String: StringView
  List: ListView
  Number: NumberView
  Void: VoidView
  Task: Task
  Settings: SettingsView
  ThrowError: ThrowErrorView
