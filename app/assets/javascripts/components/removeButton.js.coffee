App.components.removeButton = ->
  attributes: ->
    _url = @attr.url || @container.attr('href')
    {
      url:      _url
      id:       @attr.id || _url
      parentId: @attr.parentId
    }

  initialize: ->
    [@objectType, @id] = @attr.id.split('#')
    @on 'click', @doRequest

  doRequest: ->
    $.ajax
      type:     "POST"
      url:      @attr.url
      dataType: "json"
      data:     @requestData()
      success:  (data) =>
        App.mediator.publish "listItem:remove", _.extend(data, {id: @attr.id})
    false

  requestData: ->
    data = _method: "post"
    data[@objectType] = @id
    data
