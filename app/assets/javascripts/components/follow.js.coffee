App.components.follow = (container) ->
  container: container

  init: ->
    @url = @container.data('follow').url
    @addListeners()

  isActive: ->
    @container.is('.active')

  method: ->
    if @isActive() then "delete" else "post"

  requestData: ->
    _.extend {}, {"_method": @method()}

  toggleActive: ->
    if @isActive()
      @container.removeClass 'active'
    else
      @container.addClass 'active'

  doRequest: ->
    _this = this
    $.ajax
      type:     "POST"
      url:      _this.url
      dataType: "json"
      data:     _this.requestData()
      success:  _this.toggleActive.bind(_this)

  addListeners: ->
    @container.on 'click', @doRequest.bind(this)

