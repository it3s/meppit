App.components.follow = (container) ->
  container: container

  init: ->
    @data = @container.data('follow') || {}
    @url = @data.url || @container.attr('href')
    @id = @data.id || @url
    @toggleActive @data.following
    @addListeners()

  isActive: ->
    @data.following

  method: ->
    if @isActive() then "delete" else "post"

  requestData: ->
    _.extend {}, {"_method": @method()}

  toggleActive: (following) ->
    following ?= not @data.following
    @data.following = following
    if following
      @container.addClass 'active'
    else
      @container.removeClass 'active'
    @resetLabel()

  toggleLabel: ->
    if @data.following
      @container.find('> .label').text(I18n?.followings.unfollow)
    else
      @container.find('> .label').text(I18n?.followings.follow)

  resetLabel: ->
    if @data.following
      @container.find('> .label').text(I18n?.followings.following)
    else
      @container.find('> .label').text(I18n?.followings.follow)

  doRequest: ->
    _this = this
    $.ajax
      type:     "POST"
      url:      _this.url
      dataType: "json"
      data:     _this.requestData()
      success:  (data) ->
        App.mediator.publish("following:changed", _.extend(data, {id: _this.id}))
    false

  addListeners: ->
    _this = this
    @container.on 'click', @doRequest.bind(this)
    @container.on 'mouseover', @toggleLabel.bind(this)
    @container.on 'mouseout', @resetLabel.bind(this)
    App.mediator.subscribe "following:changed", (evt, data) ->
      _this.toggleActive(data.following) if data.id == _this.id
