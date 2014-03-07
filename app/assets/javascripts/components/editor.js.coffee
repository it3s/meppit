#= require tinymce

App.components.editor = (container) ->
  {
    container: container

    getLocale: ->
      $('body').data('locale').replace('-', '_')

    init: ->
      tinyMCE.init
        selector: "textarea##{@container.attr('id')}"
        theme: 'modern'
        menubar: false
        statusbar: false
        language: @getLocale()
  }
