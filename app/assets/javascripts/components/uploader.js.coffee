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

    onDone: (_this) ->
      setTimeout( ->
        _this.button.fadeOut -> _this.message.fadeIn()
      , 200)

    onAdd: (_this, data) ->
      _this.uploaderContainer.find('.error').remove()
      _this.button.text I18n.uploader.uploading
      _this.button.append "<i class=\"fa fa-spinner fa-spin\"></i>"
      data.submit()

    onFail: (_this, data) ->
      # get the corresponding error message for the container
      errors = data.jqXHR.responseJSON.errors
      err_msg = ( errors[_this.fieldName()] || ['Error'] )[0]

      _this.button.find('i').remove()
      _this.button.text I18n.uploader.select_image
      _this.button.after "<span class='error'>#{err_msg}</span>"
      _this.startPlugin() # restartPlugin (kludge for retrying uploads)

    startPlugin: ->
      @container.fileupload
        url:      @url
        type:     'PATCH'
        dataType: 'json'
        add:      (evt, data) => @onAdd(this, data)
        done:     (evt, data) => @onDone(this)
        fail:     (evt, data) => @onFail(this, data)

    init: ->
      @url = @container.closest('form').attr('action')
      @hideInput()
      @addUploaderHtml()
      @bindEvents()
      @startPlugin()
  }
