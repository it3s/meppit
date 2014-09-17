#= require jquery-fileupload/basic

uploaderTemplate = """
  <div class="uploader">
    <span class="upload-button"><%= buttonLabel %></span>
  </div>
"""

App.components.uploader = ->
  buttonLabel: I18n.uploader.select_image

  attributes: ->
    _uploader = $ _.template(uploaderTemplate, buttonLabel: @buttonLabel)
    {
      field:    @container.closest('.field')
      uploader: _uploader
      button:   _uploader.find('.upload-button')
    }

  initialize: ->
    @render()
    @on @attr.button, 'click', (evt) => @container.trigger 'click'
    @startPlugin()
    @afterInitialize?()

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

  onDone: (e, data) ->
    setTimeout( =>
      @reloadImage(data.result)
      App.utils.flashMessage(data.result.flash)
      @reset()
    , 200)

  onFail: (evt, data) ->
    @attr.button.after "<span class='error'>#{ @getErrorMsg(data) }</span>"
    @reset()

  reloadImage: (res) ->
    img = $(".avatar img")
    img.fadeOut ->
      img.attr("src", res.avatar + '?' + (new Date()).getTime()).fadeIn()

  reset: ->
    @attr.button.find('i').remove()
    @attr.button.html @buttonLabel
    @startPlugin() # restart plugin (kludge for retrying uploads)

  getErrorMsg: (data) ->
    errors = data.jqXHR.responseJSON.errors
    err_msg = (errors[ @fieldName() ] || ['Error'])[0]

  # Extract the field name.
  # E.g: <input name="user[avatar]" />  => "avatar"
  fieldName: ->
    match = @container.attr('name').match(/\[(.*?)\]/)
    if match.length > 1 then match[1] else null
