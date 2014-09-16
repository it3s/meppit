
App.components.pictureUploader = ->
  _.extend App.components.uploader(), {

    buttonLabel: "<i class='fa fa-plus'></i>Upload Picture"

    onDone: (e, data) ->
      setTimeout( =>
        # @reloadImage(data.result)
        console.log data.result
        App.utils.flashMessage(data.result.flash)
        @reset()
      , 200)

  }
