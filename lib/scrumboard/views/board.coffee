module.exports = class Board extends View

  @load: ->

    try

      JSON.parse localStorage.getItem "board"

    catch err then return false

  @save: (board) ->

    localStorage.removeItem "board"

    localStorage.setItem "board", JSON.stringify board

  @i18n:

    add: "location?"

  @content: (state) ->

    @div board: true, =>

      @div outlet: "stories", =>

      @div buttons: true, =>

        @a button: "add", click: "add", =>

          @i =>

        @a button: "copy", click: "copy", =>

          @i =>

        @a button: "paste", click: "paste", =>

          @i =>

        @a button: "save", click: "save", =>

          @i =>

        @a button: "download", click: "download", =>

          @i =>

        @a button: "delete", click: "delete", =>

          @i =>

  initialize: ->

    Model = App.Scrum.Models.Board

    @model = new Model stories: []

    Model.eventHandler @, @model

    if board = Board.load() then @putStories board.stories

    @attach()

  serialize: ->

    stories: @model.stories.map (s) -> s.serialize()

  attach: ->

    @attr("board", @uuid)

  putStories: (stories=[]) ->

    stories.map (s) =>

      @putStory s, odd = !odd

  putStory: (s, odd) ->

    s.board = @

    s.href ?= @model.href

    s.lists ?= []

    s = new App.Scrum.Views.Story s

    @model.stories.push s

    s.attr "odd", odd

    @stories.append s

  deleteStory: (uuid) ->

    @model.stories.forEach (story, index) =>

      if story.uuid is uuid

        @model.stories.splice(index, 1)

        story.destroy()

  add: ->

    href = prompt Board.i18n.add, window.location.pathname

    if href then @putStory href: href

  save: ->

    Board.save @serialize()

  download: ->

    download = @find("[button='download']")

    board = @serialize()

    board = JSON.stringify board, null, 2

    href =  "text/json;charset=utf-8,#{encodeURIComponent(board)}"

    download.attr "target", "_blank"

    download.attr "download", "scrumptious-#{new Date().getTime()}.json"

    download.attr "href", "data:#{href}"

  delete: ->

  paste: ->

  copy: ->
