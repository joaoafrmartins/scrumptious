module.exports = class Notify extends View

  @content: ->

    @div notify: true, vertical: false, horizontal: false, =>

      @div notes: true, outlet: "notes", =>

  serialize: ->

    global: @model.global

    uuid: @model.uuid

    alias: @model.alias

    vertical: @model.vertical

    horizontal: @model.horizontal

    animation: @model.animation

    timeout: @model.timeout

    timelapse: @model.timelapse

    notes: @model.notes.map (n) -> n.serialize()

    levels: @model.levels

  initialize: (state={}) ->

    state.timeout ?= 5000

    state.timelapse ?= 750

    state.animation ?= "notify"

    state.uuid ?= @uuid

    state.vertical ?= "top"

    state.horizontal ?= "right"

    state.global ?= false

    state.alias ?= "console"

    state.levels ?= ["error", "warning", "info", "success"]

    Model = App.Notify.Models.Notify

    @model = new Model state

    Model.eventHandler @, @model

    @attr "notify", @uuid

    @attr "vertical", @model.vertical

    @attr "horizontal", @model.horizontal

    printer = undefined

    if @model.global

      alias = @model.alias or "notify"

      printer = global[alias]

    printer ?= @

    @model.levels.map (l) =>

      if state.debug and l of printer

        _l = printer[l].bind printer

      printer[l] = (

        (m, o={}) ->

          o.message = m

          o.level ?= @level

          @notify o

          if state.debug and @log then @log m

      ).bind(level: l, log: _l, notify: @notify.bind(@))

      printer["#{l}Async"] = ((m, o={}, next) ->

        if typeof o is "function"

          next = o

          o = {}

        if typeof next isnt "function"

          throw new Error "#{next} is not a function"

        o.message = m

        o.level ?= @level

        if state.debug and @log then @log m

        @notify o, next

      ).bind(level: l, log: _l, notify: @notifyAsync.bind(@))

    @attach()

  attach: ->

    @parentElement ?= $ "body"

    @parentElement = $ @parentElement

    @parentElement.append @

    Object.defineProperty @, "queue", value: []

  notify: (note) ->

    @queue.push note

    return unless @queue.length is 1

    ###

      addClass(@model.animation)

      removeClass(@model.animation)

    ###

    @interval = setInterval () =>

      if n = @queue.shift()

        $note = new App.Notify.Views.Note n

        @notes.prepend $note.hide().

          fadeIn(@model.timeout * 0.1).

          delay(@model.timeout * 0.7).

          fadeOut(@model.timeout * 0.2)

      if not @queue.length then clearInterval @interval

    , @model.timelapse

  notifyAsync: (note, next) ->

    console.log note, next

    #$note.delay(@model.delay || 2).fadeOut(500)
