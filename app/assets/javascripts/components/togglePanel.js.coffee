App.components.togglePanel = (container) ->
  {
    container: container

    init: ->
      @panel = $("#{@container.attr('href')}")
      @status = 'hidden'
      @bindEvents()

    bindEvents: ->
      @container.on 'click', @toggle.bind(this)

    show: ->
      @panel.slideDown('fast')
      @status = 'visible'

    hide: ->
      @panel.slideUp('fast')
      @status = 'hidden'

    toggle: (evt) ->
      evt.preventDefault()
      if @status is 'visible' then @hide() else @show()


  }
