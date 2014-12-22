App.components.importUploader = ->
  _.extend App.components.uploader(), {

    buttonLabel: I18n.uploader.import

    afterInitialize: ->
      @method = if @attr.update then 'PATCH' else 'POST'

    onDone: (e, data) ->
      setTimeout( =>
        window.location = data.result.redirect if data.result.redirect
        @reset()
      , 200)

  }
