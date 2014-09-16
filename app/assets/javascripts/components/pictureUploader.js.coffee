
App.components.pictureUploader = ->
  _.extend App.components.uploader(), {

    buttonLabel: "<i class='fa fa-plus'></i>Upload Picture"

    pictureThumb: "<img class='thumb' src='<%= url %>' ></img>"

    onDone: (e, data) ->
      setTimeout( =>
        console.log data.result
        @addPictureThumb data.result.url
        App.utils.flashMessage(data.result.flash)
        @reset()
      , 200)

    addPictureThumb: (url) ->
      picture = $ _.template(@pictureThumb, url: url)
      $('.pictures-thumbs').append picture

  }
