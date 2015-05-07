module.exports = class List extends View

  @i18n:

    confirm: "remove list?"

  @content: (state) ->

    @li list: true, =>

      @header =>

        @span state: state?.state or "1"

        @span class: "title", outlet: "href"

      @section outlet: "section", =>

        @ul tasks: true, outlet: "tasks"

      @footer =>

        @div buttons: true, =>

          @div class: "pull-left", =>

            @a button: "delete", click: "delete", =>

                @i =>

            @a button: "cut", click: "cut", =>

              @i =>

          @div class: "pull-right", =>

            @a button: "add", click: "add", =>

              @i =>

            @a button: "copy", click: "paste", =>

              @i =>

            @a button: "paste", click: "paste", =>

              @i =>

            @a button: "link", outlet: "link", click: "go", =>

              @i =>



  serialize: ->

    _m = @model.tasks.length

    _t = @model.tasks.map (t) ->

      if t.checked then _m--

      t.serialize()

    _s =

      state: parseInt @attr "data-col"

      href: @model.href

      completed: !_m

      tasks: _t

  initialize: (state) ->

    Model = App.Scrum.Models.List

    @model = new Model state

    Model.eventHandler @, @model

    @attr "id", @uuid

    @href.text @model.href or "/"

    @link.attr "href", @model.href

    @link.attr "target", "_blank"

    @attach()

  attach: ->

    tasks = []

    while t = @model?.tasks?.shift() then tasks.push t

    tasks.map (t) => @putTask t

  putTask: (t={}) ->

    t.list = @

    t.href ?= @model.href

    t = new App.Scrum.Views.Task t

    @model.tasks.push t

    @tasks.append t

    @model.completed = @model.tasks.map(

      (t) ->

        if t.completed then 1 else 0

    ).reduce(

      (t, sum) ->

        sum ?= 0

        sum += t

    ) == @model.tasks.length

    @closest

    t

  deleteTask: (uuid) ->

    @model.tasks.forEach (task, index) =>

      if task.uuid is uuid

        @model.tasks.splice(index, 1)

        task.destroy()

        false

    false

  go: (e) ->

    e.stopPropagation

  delete: ->

    if confirm List.i18n.confirm

      @model.story.deleteList @uuid

    false

  add: (e) ->

    t = @putTask()

    t.addClass "edit"

    e.preventDefault()

    e.stopPropagation()

    false
