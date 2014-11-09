overlayTemplate = """
  <div class="overlay <%= style %>">
    <div class="overlay-message"><%= message %></div>
  </div>
"""

App.components.overlay = ->
  attributes: ->
    style:   @attr.style   || 'dark'
    message: @attr.message || ''

  initialize: ->
    @render()

  render: ->
    @overlay = $ _.template(overlayTemplate)(@attr)
    @container.css 'position', 'relative'
    @container.prepend @overlay
