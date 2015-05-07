module.exports = class Toolbar extends View

  @plugins: (state) ->

    "board": ->

      view = new App.Scrum.Views.Board state.board

      view

  @content: (state) ->

    @div toolbar: true, =>

      @div outlet: "slideshow"

      @div buttons: true, class: "btn-toolbar btn-toolbar-sm", =>

        @div class: "btn-group pull-right", =>

          @a button: "list", click: "list", =>

            @i =>

  serialize: ->

  initialize: (state={}) ->

    @parentElement ?= state.parentElement

    Model = App.Toolbar.Models.Toolbar

    Slideshow = App.Slideshow.Views.Slideshow

    state.uuid ?= @uuid

    @attr "toolbar", @uuid

    @model = new Model state

    Model.eventHandler @, @model

    @slideshow = new Slideshow Toolbar.plugins state

    @attach()

  attach: ->

    @parentElement ?= $("body")

    @parentElement = $ @parentElement

    @parentElement.prepend @

  list: (e) ->

    $el = @closest("body").find("[slideshow] [slide]")

    $el.toggleClass("play")
