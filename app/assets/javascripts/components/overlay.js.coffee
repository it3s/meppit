App.components.overlay = (container) ->
  {
    container: container

    overlayElement: """<div class="overlay"></div>"""

    init: ->
      @container.css 'position', 'relative'
      @container.prepend @overlayElement

  }
