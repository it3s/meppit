#= require jquery.sticky
#
App.components.stick = (container) ->
  {
    container: container,

    init: ->
      data = @container.data 'stick'

      @container.sticky
        className: 'stick'
        wrapperClassName: 'stick-wrapper'
        topSpacing: data?.top_spacing
        bottomSpacing: data?.bottom_spacing
        getWidthFrom: data?.get_width_from

  }
