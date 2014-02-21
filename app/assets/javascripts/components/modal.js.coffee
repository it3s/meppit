#= require jquery.modal

App.components.modal = (container) ->
  {
    container: container,

    fadeDuration: 150,

    init: ->
      @data = JSON.parse(@container.attr('data-modal') || '{}')
      @start()

    refered_element: ->
      $("#{ @container.attr('href') }")

    open: (_this, target) ->
      opts = {fadeDuration: _this.fadeDuration}
      if _this.data.prevent_close
        opts = _.extend(opts, {
          escapeClose: false,
          clickClose: false,
          closeText: '',
          showClose: false,
        })
      target.modal(opts)
      false

    ajax_complete: (_this) ->
      setTimeout( ->
        current_modal = $('.modal.current')
        App.mediator.publish('components:start', current_modal)
      , _this.fadeDuration)

    start: ->
      target = if @data.remote then @container else @refered_element()

      # bind click to open modal
      @container.on 'click', (el) => @open(this, target)

      # trigger components:start for ajax loaded elements
      @container.on 'modal:ajax:complete', (evt, data) => @ajax_complete(this)

      @open(this, @container) if @data.autoload
  }
