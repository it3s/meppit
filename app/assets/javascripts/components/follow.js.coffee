App.components.follow = ->
  attributes: ->
    _url = @attr.url || @container.attr('href')
    {
      url:   _url
      id:    @attr.id || _url
      label: @container.find('> .label')
    }

  initialize: ->
    @toggleActive @attr.following

    @on 'click', @doRequest
    @on 'mouseover', @toggleLabel
    @on 'mouseout', @resetLabel
    App.mediator.subscribe "following:changed", (evt, data) =>
      @toggleActive(data.following) if data.id == @attr.id

  doRequest: ->
    $.ajax
      type:     "POST"
      url:      @attr.url
      dataType: "json"
      data:     @requestData()
      success:  (data) =>
        App.mediator.publish "following:changed", _.extend(data, {id: @attr.id})
    false

  requestData: ->
    {_method: if @attr.following then "delete" else "post"}

  isActive: ->
    @container.is('.active')

  toggleActive: (following) ->
    following ?= not @attr.following
    @attr.following = following
    if following then @container.addClass('active') else @container.removeClass('active')
    @resetLabel()

  toggleLabel: ->
    @attr.label.text I18n.followings[ if @attr.following then 'unfollow' else 'follow' ]

  resetLabel: ->
    @attr.label.text I18n.followings[ if @attr.following then 'following' else 'follow' ]
