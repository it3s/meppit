App.components.exporter = ->
  attributes: ->
    option: @container.find('.option')

  initialize: ->
    @on @attr.option, 'click', @closeModal

  closeModal: ->
    App.mediator.publish 'modal:close'
