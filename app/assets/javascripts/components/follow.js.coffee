App.components.follow = (container) ->
  container: container

  init: ->
    @data = @container.data('follow') || {}
    @url = @data.url || @container.attr('href')
    @toggleActive @data.following
    @addListeners()

  isActive: ->
    @data.following

  method: ->
    if @isActive() then "delete" else "post"

  requestData: ->
    _.extend {}, {"_method": @method()}

  toggleActive: (following) ->
    @data.following = following
    if following
      @container.addClass 'active'
    else
      @container.removeClass 'active'
    @resetLabel()

  toggleLabel: ->
    if @data.following
      @container.find('> .label').text(I18n.followings.unfollow)
    else
      @container.find('> .label').text(I18n.followings.follow)

  resetLabel: ->
    if @data.following
      @container.find('> .label').text(I18n.followings.following)
    else
      @container.find('> .label').text(I18n.followings.follow)

  doRequest: ->
    _this = this
    $.ajax
      type:     "POST"
      url:      _this.url
      dataType: "json"
      data:     _this.requestData()
      success:  (data) -> _this.toggleActive(data.following)
    false

  addListeners: ->
    @container.on 'click', @doRequest.bind(this)
    @container.on 'mouseover', @toggleLabel.bind(this)
    @container.on 'mouseout', @resetLabel.bind(this)
