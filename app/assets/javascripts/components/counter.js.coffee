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

  addListeners: ->
    _this = this
    if @type == 'followers'
      App.mediator.subscribe "following:changed", (evt, data) ->
        _this.updateLabel(data.count) if data.id == _this.id
