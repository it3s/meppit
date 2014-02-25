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

    open: (_this) ->
      opts = _.clone(_this.defaults)
      opts = _.extend(opts, _this.preventClose) if _this.data.prevent_close
      _this.target.modal(opts)
      false

    startComponents: (time=0) ->
      setTimeout( ->
        currentModal = $('.modal.current')
        App.mediator.publish('components:start', currentModal)
      , time)

    start: ->
      if @data.autoload
        @open(this)
      else
        @container.on 'click', => @open(this)

      if @data.remote
        # trigger components:start for ajax loaded elements
        @container.on 'modal:ajax:complete', => @startComponents(@defaults.fadeDuration)

  }
