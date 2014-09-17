
App.components.pictureUploader = ->
  _.extend App.components.uploader(), {

    buttonLabel: "<i class='fa fa-plus'></i>Upload Picture"

    picturesList: $('.pictures-thumbs')

    pictureThumb: """
    <li data-picture_id="<%= id %>" >
      <a href='<%= show_url %>' class='thumb' data-components='modal' data-modal-options='{"remote":"true"}'>
        <img class='thumb-image' src='<%= image_url %>' ></img>
      </a>
    </li>
    """

    afterInitialize: ->
      App.mediator.subscribe "picture:updated", @onUpdate.bind(this)
      App.mediator.subscribe "picture:deleted", @onDelete.bind(this)

    onDone: (e, data) ->
      setTimeout( =>
        console.log data.result
        @addPictureThumb data.result
        App.utils.flashMessage(data.result.flash)
        @reset()
      , 200)

    addPictureThumb: (result) ->
      picture = $ _.template(@pictureThumb, result)
      @picturesList.prepend picture
      App.mediator.publish 'components:start', picture

    onUpdate: (evt, data) ->
      @picturesList.find("[data-picture_id=#{data.id}]").attr('title', data.description)

    onDelete: (evt, data) ->
      console.log 'picture:deleted', data

  }
