App.components.counter = (container) ->
  container: container
  counter: container.find('.counter-label')

  init: ->
    @data = @container.data('counter') || {}
    @id = @data.id
    @type = @data.type
    @addListeners()

  updateLabel: (count) ->
    @counter.text count

  eventName: ->
    {
      'followers': 'following:changed'
      'maps'     : 'mapping:changed'
      'geo_data' : 'mapping:changed'
    }[@type]

  addListeners: ->
    _this = this
    App.mediator.subscribe @eventName(), (evt, data) ->
      _this.updateLabel(data.count) if data.id == _this.id
