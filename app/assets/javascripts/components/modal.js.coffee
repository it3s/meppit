#= require jquery.modal

App.components.modal = (container) ->
  {
    container: container,

    init: ->
      @ref =  @container.attr('id');
      @start()

    start: ->
      # @container.modal()
      $("a[data-modal=open][href='##{ @ref }']").on 'click', (el) =>
        @container.modal( fadeDuration: 150 )
        false
      console.log('components: started modal');
  }
