App.components.featuredButton = ->
  attributes: ->
    _url = @attr.url || @container.attr('href')
    {
      url:_url
      id:  @attr.id || _url
    }

  initialize: ->
    @toggleActive @attr.featured

    @on 'click', @doRequest
    App.mediator.subscribe "featured:changed", (evt, data) =>
      @toggleActive(data.featured) if data.id == @attr.id

  doRequest: ->
    $.ajax
      type:     "POST"
      url:      @attr.url
      dataType: "json"
      data:     @requestData()
      success:  (data) =>
        App.mediator.publish "featured:changed", _.extend(data, {id: @attr.id})
    false

  requestData: ->
    {_method: if @attr.featured then "delete" else "post"}

  toggleActive: (featured) ->
    featured ?= not @attr.featured
    @attr.featured = featured
    if featured then @container.addClass('active') else @container.removeClass('active')
