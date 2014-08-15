#= require jquery-fileupload/basic

uploaderTemplate = """
  <div class="uploader">
    <div class="upload-success">#{I18n.uploader.uploaded}</div>
    <span class="upload-button">#{I18n.uploader.select_image}</span>
  </div>
"""

App.components.uploader = ->
  attributes: ->
    _uploader = $(uploaderTemplate)
    {
      field:    @container.closest('.field')
      url:      @container.closest('form').attr('action')
      uploader: _uploader
      button:   _uploader.find('.upload-button')
      message:  _uploader.find('.upload-success')
    }

  initialize: ->
    @render()
    @on @attr.button, 'click', (evt) => @container.trigger 'click'
    @startPlugin()

  render: ->
    @attr.field.hide()
    @attr.field.after @attr.uploader

  startPlugin: ->
    @container.fileupload
      url:      @attr.url
      type:     'PATCH'
      dataType: 'json'
      add:      @onAdd.bind(this)
      done:     @onDone.bind(this)
      fail:     @onFail.bind(this)

  onAdd: (evt, data) ->
    @attr.uploader.find('.error').remove()
    @attr.button.text I18n.uploader.uploading
    @attr.button.append "<i class=\"fa fa-spinner fa-spin\"></i>"
    data.submit()

  onDone: ->
    setTimeout @showMessage.bind(this), 200

  onFail: (evt, data) ->
    @attr.button.find('i').remove()
    @attr.button.text I18n.uploader.select_image
    @attr.button.after "<span class='error'>#{ @getErrorMsg(data) }</span>"
    @startPlugin() # restart plugin (kludge for retrying uploads)

  showMessage: ->
    @attr.button.fadeOut => @attr.message.fadeIn()

  getErrorMsg: (data) ->
    errors = data.jqXHR.responseJSON.errors
    err_msg = (errors[ @fieldName() ] || ['Error'])[0]

  # Extract the field name.
  # E.g: <input name="user[avatar]" />  => "avatar"
  fieldName: ->
    match = @container.attr('name').match(/\[(.*?)\]/)
    if match.length > 1 then match[1] else null
