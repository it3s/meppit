App.components.featureButton = ->
  attributes: ->
    _url = @attr.url || @container.attr('href')
    {
      url:_url
      id:  @attr.id || _url
    }

  initialize: ->
    @toggleActive @attr.isFeatured

    @on 'click', @doRequest
    App.mediator.subscribe "is_featured:changed", (evt, data) =>
      @toggleActive(data.is_featured) if data.id == @attr.id

  doRequest: ->
    $.ajax
      type:     "POST"
      url:      @attr.url
      dataType: "json"
      data:     @requestData()
      success:  (data) =>
        App.mediator.publish "is_featured:changed", _.extend(data, {id: @attr.id})
    false

  requestData: ->
    {_method: if @attr.isFeatured then "delete" else "post"}

  toggleActive: (isFeatured) ->
    isFeatured ?= not @attr.isFeatured
    @attr.isFeatured = isFeatured
    if isFeatured then @container.addClass('active') else @container.removeClass('active')
