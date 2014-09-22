
App.components.importUploader = ->
  _.extend App.components.uploader(), {

    buttonLabel: I18n.uploader.import

    afterInitialize: ->
      console.log 'afterInitialize: bind evts here'

    onDone: (e, data) ->
      setTimeout( =>
        console.log data
        # App.utils.flashMessage(data.result.flash)
        @reset()
      , 200)

  }
