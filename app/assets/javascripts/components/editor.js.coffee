#= require tinymce

App.components.editor = (container) ->
  {
    container: container

    defaults:
      theme: 'modern'
      menubar: false
      statusbar: false
      height: 350

    getLocale: ->
      $('body').data('locale').replace('-', '_')

    options: ->
      _.extend {}, @defaults, {
        selector: "textarea##{@container.attr('id')}"
        language: @getLocale()
        height: @container.attr('data-height') or @defaults.height
      }

    init: ->
      tinyMCE.init @options()
  }
