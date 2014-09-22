
App.components.importUploader = ->
  _.extend App.components.uploader(), {

    buttonLabel: I18n.uploader.import

    method: 'POST'

    afterInitialize: ->
      console.log 'afterInitialize: bind evts here'

    onDone: (e, data) ->
      setTimeout( =>
        console.log data.result
        window.location = data.result.redirect if data.result.redirect
        @reset()
      , 200)

  }
