#= require jquery.modal

App.components.modal = (container) ->
  {
    container: container,

    defaults: {
      fadeDuration: 150,
    }

    prevent_close: {
      escapeClose: false,
      clickClose: false,
      closeText: '',
      showClose: false,
    }

    init: ->
      @data = JSON.parse(@container.attr('data-modal') || '{}')
      @start()

    refered_element: ->
      $("#{ @container.attr('href') }")

    open: (_this) ->
      opts = _.clone(_this.defaults)
      opts = _.extend(opts, _this.prevent_close) if _this.data.prevent_close
      _this.target.modal(opts)
      false

    start_components: (time=0) ->
      setTimeout( ->
        current_modal = $('.modal.current')
        App.mediator.publish('components:start', current_modal)
      , time)

    start: ->
      @target = if @data.remote || @data.autoload then @container else @refered_element()

      if @data.autoload
        @open(this)
      else
        # bind click to open modal
        @container.on 'click', => @open(this)

      if @data.remote
        # trigger components:start for ajax loaded elements
        @container.on 'modal:ajax:complete', => @start_components(@defaults.fadeDuration)

  }
