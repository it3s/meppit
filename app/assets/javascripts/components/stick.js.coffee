#= require jquery.sticky

App.components.stick = (container) ->
  attributes: ->
    topSpacing:    0
    bottomSpacing: 0
    getWidthFrom:  ''

  initialize: ->
    @startPlugin()

  startPlugin: ->
    @container.sticky
      className:        'stick'
      wrapperClassName: 'stick-wrapper'
      topSpacing:       @attr.top_spacing
      bottomSpacing:    @attr.bottom_spacing
      getWidthFrom:     @attr.get_width_from
