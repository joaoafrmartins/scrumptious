module.exports = class Slideshow extends View

  @content: ->

    @div slideshow: true, =>

  initialize: (state={}, blacklist=["uuid"]) ->

    @parentElement ?= state.parentElement

    { keys } = Object

    slides = {}

    keys(state).map (plugin) =>

      if plugin in blacklist then return

      slides[plugin] = state[plugin]

    state.uuid ?= @uuid

    @attr "slideshow", @uuid

    state.slides = slides

    Model = App.Slideshow.Models.Slideshow

    @model = new Model state

    Model.eventHandler @, @model

    _slides = []

    _keys = keys(@model.slides)

    while k = _keys.shift() then _slides.push slides[k]

    @slides = _slides.map (s) => @addSlide s

    @attach()

  attach: ->

    @parentElement ?= $("body")

    @parentElement = $ @parentElement

    @parentElement.prepend @

  addSlide: (s) ->

    Slide = App.Slideshow.Views.Slide

    s = new Slide s

    s.attr "slide", s.uuid

    @append s

    s
