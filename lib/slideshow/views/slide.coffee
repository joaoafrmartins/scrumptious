module.exports = class Slide extends View

  @content: ->

    @section slide: "true", class: "play", =>

  initialize: (view, state={}) ->

    state.uuid ?= @uuid

    Model = App.Slideshow.Models.Slide

    @model = new Model state

    Model.eventHandler @, @model

    @slide = view()

    @append @slide

    @attr "slide", @slide.uuid

  attach: ->
