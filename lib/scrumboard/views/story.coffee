Gridster = require 'gridster/src/jquery.gridster.js'

module.exports = class Story extends View

  @i18n:

    confirm: "remove story?"

  @content: (state) ->

    @div story: true, class: "gridster", =>

      @div buttons: true, =>

        @div class: "pull-left", =>

          @a button: "delete", click: "delete", =>

            @i =>

          @a button: "cut", click: "cut", =>

            @i =>

        @div class: "pull-right", =>

          @a button: "add", click: "add", =>

            @i =>

          @a button: "copy", click: "copy", =>

            @i =>

          @a button: "paste", click: "paste", =>

            @i =>

          @a button: "link", outlet: "link", click: "go", =>

            @i =>

      @ul outlet: "story", class: "story"

  serialize: ->

    href: @model.href

    lists: @model.lists.map (l) -> l.serialize()

  initialize: (@state) ->

    Model = App.Scrum.Models.Story

    @model = new Model @state

    Model.eventHandler @, @model

    @model.href ?= "/"

    @link.attr "href", @model.href

    @link.attr "target", "_blank"

    @attach()

  attach: ->

    @parentElement ?= @state?.board or $("body")

    @parentElement = $ @parentElement

    @parentElement.append @

    @attr("story", @uuid)

    _options =

      namespace: "[story]"

      min_cols: 5

      max_cols: 5

      autogrow_rows: true

      autogenerate_stylesheet: false

    @story = new Gridster @story[0], _options

    @clear()

    lists = []

    while l = @model.lists.shift() then lists.push l

    lists.map (l) => @putList l

  clear: ->

    @?story?.remove_all_widgets()

  putList: (l={}) ->

    l.story = @

    l.href ?= @model.href

    l.tasks ?= []

    l = new App.Scrum.Views.List l

    @model.lists.push l

    { state: col } = l.model

    l = @story.add_widget(

      l[0], x=1, y=1, col?=1, row=1

    )

    @story.resize_widget(l)

    l

  deleteList: (uuid) ->

    @model.lists.forEach (list, index) =>

      if list.uuid is uuid

        @model.lists.splice(index, 1)

        list.destroy()

  delete: ->

    if confirm Story.i18n.confim

      @model.board.deleteStory @uuid

    false

  add: (e) ->

    e.stopPropagation()

    l = @putList()

    ###l.add(e)###

    false

  go: (e) ->

    e.stopPropagation()
