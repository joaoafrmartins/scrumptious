global.$ = require 'jquery'

global.jQuery = $

{ View } = require 'space-pen'

{ Model, Sequence: global.Sequence } = require 'theorist'

global.View = class VUuid extends View

  @uuid: ->

    uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'

    uuid.replace(/[xy]/g,

        (c) ->
          r = Math.random() * 16 | 0
          v = if c is 'x' then r else (r & 0x3|0x8)
          v.toString(16)
    )

  constructor: ->

    Object.defineProperty @, "uuid", value: VUuid.uuid()

    super

  destroy: ->

    delete @model

    @detach()

global.Model = class ViewModel extends Model

  @eventHandler: (v, m) ->

    m.uuid = v.uuid

    { keys, defineProperty } = Object

    defineProperty m, "$el", value: v

    keys(m.declaredPropertyValues or {}).map (key) =>

      capitalized = key.charAt(0).toUpperCase() +

        key.slice(1, key.length)

      if "on#{capitalized}Value" of v

        m["$#{key}"].onValue v["on#{capitalized}Value"].bind v

  @type: (obj) ->

    if obj == undefined or obj == null
      return String obj
    classToType = {
      '[object Boolean]': 'boolean',
      '[object Number]': 'number',
      '[object String]': 'string',
      '[object Function]': 'function',
      '[object Array]': 'array',
      '[object Date]': 'date',
      '[object RegExp]': 'regexp',
      '[object Object]': 'object'
    }

    return classToType[Object.prototype.toString.call(obj)]


global.Mixin = require 'mixto'

global.App =

  Clipboard: require './clipboard/index.coffee'

  Toolbar: require './toolbar/index.coffee'

  Slideshow: require './slideshow/index.coffee'

  Scrum: require './scrumboard/index.coffee'

  Notify: require './notify/index.coffee'
