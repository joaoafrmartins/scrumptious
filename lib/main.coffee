console.clear()

### LESS ###

require './../theme/index.less'

### GLOBALS ###

require './globals.coffee'

$ ->

  window.Toolbar = new App.Toolbar.Views.Toolbar

  window.Notify = new App.Notify.Views.Notify

    vertical: "top"

    horizontal: "left"

    global: true
