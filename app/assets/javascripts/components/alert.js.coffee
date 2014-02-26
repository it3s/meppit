#= require jquery.flexslider

App.components.alert = (container) ->
  {
    container: container,

    init: ->
      @bindEvents()

    onClose: (_this) ->
      alertsContainer = _this.container.closest('.alerts')
      _this.container.fadeOut 200, ->
        this.remove()
        alertsContainer.remove() if alertsContainer.find('.alert').length is 0

    bindEvents: ->
      @container.find('.close').on 'click', => @onClose(this)
  }
