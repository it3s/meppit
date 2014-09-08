App.components.selector = ->
  initialize: ->
    @baseURL = @attr.url ? "#{window.location.pathname}"
    @getQueryValues()
    @getParams()
    @updateValues()
    @bindEvents()
    @updateDisplay()

  getQueryValues: ->
    @queryValues = _.reduce(window.location.search.substr(1).split('&'), (ret, param) ->
      parts = param.replace(/\+/g, ' ').split('=')
      key = decodeURIComponent(parts[0])
      val = parts[1]
      val = if not val? then null else decodeURIComponent(val)
      if not ret[key]?
        ret[key] = val
      else if _.isArray ret[key]
        ret[key].push val
      else
        ret[key] = [ret[key], val]
      return ret
    , {})

  getParams: ->
    selectors = $(".options")
    @params ?= {}
    for selector in selectors
      selector = $ selector
      paramName = selector.data "selector-param"
      defaultValue = selector.find('.option[data-selector-default]').data "selector-value"
      @params[paramName] ?=
        name: paramName
        selector: selector
        default: defaultValue
        value: @queryValues[paramName]
    @params

  updateValue: (param) ->
    value = param.value ? param.default
    selectedOption = param.selector.find(".option").filter ->
      $(this).data("selector-selected") is true
    value = selectedOption.data "selector-value" if selectedOption.length > 0
    param.value = value

  updateValues: ->
    for paramName, param of @params
      @updateValue param

  updateDisplay: ->
    for paramName, param of @params
      param.selector.find(".option").each (idx, el) ->
        el = $ el
        selected = el.data("selector-value") is param.value
        el.data "selector-selected", selected
        if not selected then el.removeClass("selected") else el.addClass("selected")

  changeValue: (param, value) ->
    return if param.value is value
    param.value = value
    @loadURL() if @attr.autoload
    @updateDisplay()

  bindEvents: ->
    that = this
    for paramName, param of @params
      param.selector.find(".option").click ((param) ->
        (evt) ->
          evt.preventDefault()
          value = $(this).data "selector-value"
          that.changeValue param, value
      )(param)

  onSuccess: (data) ->
    content = $(data).find(@attr.target)
    $(@attr.target).replaceWith content
    App.mediator.publish "components:start", content

  getURL: ->
    urlParams = {}
    for paramName, param of @params
      urlParams[paramName] = param.value if param.value?
    urlParams_ = $.param urlParams
    "#{@baseURL}?#{urlParams_}#{window.location.hash}"

  loadURL: ->
    if @attr.remote
      $.get @getURL(), @onSuccess.bind(this)
    else
      window.location = @getURL()
