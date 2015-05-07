###

https://github.com/zeroclipboard/zeroclipboard

https://github.com/valeriansaliou/jquery.clipboard

window.addEventListener "copy", (e) ->

  console.log "copy", e

window.addEventListener "paste", (e) ->

  console.log "paste", e

$(window).trigger "copy"

$(window).trigger "paste"

###

module.exports = class Clipboard extends Mixin

  @copy: ->

  @paste: ->

  @cut: ->

  copy: (e) ->

  paste: (e) ->

  cut: ->
