
App.components.pictureUploader = ->
  _.extend App.components.uploader(), {

    buttonLabel: "<i class='fa fa-plus'></i>Upload Picture"

    pictureThumb: """
    <a href='<%= show_url %>' class='thumb' data-components='modal' data-modal-options='{"remote":"true"}'>
      <img class='thumb-image' src='<%= image_url %>' ></img>
    </a>
    """

    onDone: (e, data) ->
      setTimeout( =>
        console.log data.result
        @addPictureThumb data.result
        App.utils.flashMessage(data.result.flash)
        @reset()
      , 200)

    addPictureThumb: (result) ->
      picture = $ _.template(@pictureThumb, result)
      $('.pictures-thumbs').append picture

  }
