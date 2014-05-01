App.components.overlay = (container) ->
  {
    container: container

    overlayElement: """<div class="overlay"></div>"""
    overlayMessage: """<div class="overlay-message"></div>"""

    init: ->
      data = @container.data('overlay')
      overlay = @createOverlay(data)
      @inject overlay

    createOverlay: (data) ->
      overlay = $(@overlayElement)

      # toggle dark/light
      overlay.addClass(data.style) if data?.style

      overlay.append(@createMessage data) if data?.message
      overlay

    createMessage: (data)->
      message = $(@overlayMessage)
      message.text(data.message)
      message

    inject: (overlay) ->
      @container.css 'position', 'relative'
      @container.prepend overlay

  }
