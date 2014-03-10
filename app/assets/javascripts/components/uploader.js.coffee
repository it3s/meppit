#= require jquery-fileupload/basic

App.components.uploader = (container) ->
  {
    container: container

    hideInput: ->
      @container.closest('.field').hide()

    addUploaderHtml: ->
      uploaderContainer = $("""
        <div class="uploader">
          <div class="upload-success">File Uploaded. Refresh or Save</div>
          <span class="upload-button">Select File</span>
        </div>
      """)
      @container.closest('.field').after uploaderContainer
      @message = uploaderContainer.find('.upload-success')
      @button = uploaderContainer.find('.upload-button')

    bindEvents: ->
      @button.on 'click', (evt) => @container.trigger 'click'

    onDone: (_this) ->
      setTimeout( ->
        _this.button.fadeOut -> _this.message.fadeIn()
      , 200)

    onAdd: (_this, data) ->
      _this.button.text 'Uploading ...'
      _this.button.append "<i class=\"fa fa-spinner fa-spin\"></i>"
      data.submit()

    startPlugin: ->
      @container.fileupload
        dataType: 'json'
        add:      (evt, data) => @onAdd(this, data)
        done:     (evt, data) => @onDone(this)

    init: ->
      @hideInput()
      @addUploaderHtml()
      @bindEvents()
      @startPlugin()
  }
