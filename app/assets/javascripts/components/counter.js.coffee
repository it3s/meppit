App.components.counter = ->
  attributes: ->
    counter: @container.find('.counter-label')

  initialize: ->
    App.mediator.subscribe @eventName(), (evt, data) =>
      @updateLabel(data.count) if data.id is @attr.id

  eventName: ->
    {
      'followers': 'following:changed'
      'maps'     : 'mapping:changed'
      'geo_data' : 'mapping:changed'
    }[@attr.type]

  updateLabel: (count) ->
    @attr.counter.text count
