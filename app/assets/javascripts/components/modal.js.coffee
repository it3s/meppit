#= require jquery.modal

App.components.modal = (container) ->
  {
    container: container,

    fadeDuration: 150,

    init: ->
      @start()

    is_remote: ->
      !(/^#/).test(@container.attr 'href' )

    refered_element: ->
      $("#{ @container.attr('href') }")

    start: ->
      target = if @is_remote() then @container else @refered_element()

      # bind click to open modal
      @container.on 'click', (el) =>
        target.modal( fadeDuration: @fadeDuration )
        false

      # trigger components:start for ajax loaded elements
      @container.on 'modal:ajax:complete', (evt, data) =>
        setTimeout( ->
          current_modal = $('.modal.current')
          App.mediator.publish('components:start', current_modal)
        , @fadeDuration)

  }
