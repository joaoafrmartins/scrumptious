module.exports = class Task extends View

  @i18n:

    taskPlaceholder: "new task..."

    taskConfirmDelete: "remove task?"

    taskDeleted: "task removed"

    taskCompleted: "task completed"

    taskIncomplete: "task incomplete"

  @content: (state) ->

    { href, title, description, checked } = state

    @li task: true, checked: !!checked, =>

      @input click: "toggle", outlet: "checkbox", type: "checkbox"

      @label outlet: "label", =>

        @textarea( placeholder: Task.i18n.placeholder,
          editor: true,
          outlet: "editor",
          blur: "edit"
        )

        @div class: "task", outlet: "task"

        @div buttons: true, =>

          @div class: "pull-left", =>

            @a button: "delete", click: "delete", =>

              @i =>

            @a button: "cut", click: "cut", =>

              @i =>

          @div class: "pull-right", =>

            @a button: "edit", click: "edit", =>

              @i =>

            @a button: "copy", click: "copy", =>

              @i =>

            @a button: "link", outlet: "link", click: "go", =>

              @i =>

  serialize: ->

    href: @model.href

    task: @model.task

    checked: @model.checked

  initialize: (state={}) ->

    state.task ?= Task.i18n.taskPlaceholder

    @model = new App.Scrum.Models.Task state

    Model.eventHandler @, @model

    @checkbox.attr "id", @uuid

    @label.attr "for", @uuid

    @task.text @model.task

    @link.attr "href", @model.href

    @link.attr "target", "_blank"

    @attach()

  attach: ->

  toggle: ->

    if @model.checked = @checkbox.is(":checked")

      console.success Task.i18n.taskCompleted

    else

      console.warning Task.i18n.taskIncomplete

  go: ->

    e.stopPropagation

  edit: ->

    @editor.removeClass "error"

    if @hasClass "edit"

      if text = @editor.val()

        @model.task = text

        @task.text text

        @removeClass "edit"

      @editor.addClass "error"

    else

      @addClass "edit"

      @editor.val @model.task

      @editor.focus()

    false

  delete: ->

    if confirm Task.i18n.taskConfirmDelete

      @model.list.deleteTask @uuid

      console.info Task.i18n.taskDeleted

    false
