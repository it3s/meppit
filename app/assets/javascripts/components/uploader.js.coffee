#= require jquery-fileupload/basic

App.components.uploader = (container) ->
  {
    container: container

    hideInput: ->
      @container.closest('.field').hide()

    fieldName: ->
      # <input name="user[avatar]" />  => "avatar"
      match = @container.attr('name').match(/\[(.*?)\]/)
      if match.length > 1 then match[1] else null

    addUploaderHtml: ->
      uploaderContainer = $("""
        <div class="uploader">
          <div class="upload-success">#{I18n.uploader.uploaded}</div>
          <span class="upload-button">#{I18n.uploader.select_image}</span>
        </div>
      """)
      @container.closest('.field').after uploaderContainer
      @message = uploaderContainer.find('.upload-success')
      @button = uploaderContainer.find('.upload-button')
      @uploaderContainer = uploaderContainer

    bindEvents: ->
      @button.on 'click', (evt) => @container.trigger 'click'

    onDone: () ->
      setTimeout( =>
        @button.fadeOut => @message.fadeIn()
      , 200)

    onAdd: (evt, data) ->
      @uploaderContainer.find('.error').remove()
      @button.text I18n.uploader.uploading
      @button.append "<i class=\"fa fa-spinner fa-spin\"></i>"
      data.submit()

    onFail: (evt, data) ->
      # get the corresponding error message for the container
      errors = data.jqXHR.responseJSON.errors
      err_msg = ( errors[@fieldName()] || ['Error'] )[0]

      @button.find('i').remove()
      @button.text I18n.uploader.select_image
      @button.after "<span class='error'>#{err_msg}</span>"
      @startPlugin() # restart plugin (kludge for retrying uploads)

    startPlugin: ->
      @container.fileupload
        url:      @url
        type:     'PATCH'
        dataType: 'json'
        add:      @onAdd.bind(this)
        done:     @onDone.bind(this)
        fail:     @onFail.bind(this)

    init: ->
      @url = @container.closest('form').attr('action')
      @hideInput()
      @addUploaderHtml()
      @bindEvents()
      @startPlugin()
  }
