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

    onEditorChange: (ed)->
      App.mediator.publish 'tinymce:changed', {id: @container.attr('id'), content: ed.target.getContent()}

    options: ->
      _.extend {}, @defaults, {
        selector: "textarea##{@container.attr('id')}"
        language: @getLocale()
        height: @container.attr('data-height') or @defaults.height
        setup: (ed) =>
          ed.on 'change', _.debounce(@onEditorChange).bind(this)
      }

    init: ->
      tinyMCE.init @options()
  }
