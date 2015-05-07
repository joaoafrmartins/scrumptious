module.exports = class Note extends View

  @content: ->

    @article note: true, level: true, =>

      @legend title: true, =>

        @i icon: true, =>

        @i outlet: "title", =>

        @i close: true, =>

      @div envelope: true, =>

        @a message: true, outlet: "message", =>

  serialize: ->

    level: @model.level

    title: @model.title

    message: @model.message

    href: @model.href

    target: @model.target

  initialize: (state) ->

    state.uuid ?= @uuid

    state.target ?= "_blank"

    Model = App.Notify.Models.Note

    @model = new Model state

    Model.eventHandler @, @model

    @attr "note", @uuid

    { level, title, message, href, target } = @model

    level ?= "info"

    title ?= level

    if level then @attr "level", level

    if title then @title.text title

    if message then @message.text message

    if href then @message.attr "href", href

    if target then @message.attr "target", target
