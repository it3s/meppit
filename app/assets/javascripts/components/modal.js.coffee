#= require jquery.modal

App.components.modal = (container) ->
  {
    container: container

    defaults: {
      fadeDuration: 150
      zIndex: 200
    }

    # options for preventing close on autloaded modals
    preventClose: {
      escapeClose: false
      clickClose: false
      closeText: ''
      showClose: false
    }

    init: ->
      @data = JSON.parse(@container.attr('data-modal') || '{}')
      @target = if @data.remote || @data.autoload then @container else @referedElement()
      @start()

    referedElement: ->
      $("#{ @container.attr('href') }")

    open: () ->
      opts = _.clone(@defaults)
      opts = _.extend(opts, @preventClose) if @data.prevent_close
      @target.modal(opts)
      false

    startComponents: () ->
      setTimeout( ->
        currentModal = $('.modal.current')
        App.mediator.publish('components:start', currentModal)
      , @defaults.fadeDuration)

    start: ->
      if @data.autoload
        @open(this)
      else
        @container.on 'click', @open.bind(this)

      if @data.remote
        # trigger components:start for ajax loaded elements
        @container.on 'modal:ajax:complete', @startComponents.bind(this)

  }
