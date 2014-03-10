#= require jquery-fileupload/basic

App.components.uploader = (container) ->
  {
    container: container

    addProgressBar: ->
      @container.after """
        <div id="progress">
            <div class="bar" style="width: 0%;"></div>
        </div>
      """

    init: ->
      @addProgressBar()
      @container.fileupload
        dataType: 'json'
        done: (e, data) =>
          _.each data.result.files, (file) =>
            @container.after("<p>#{file.name}</p>")
        progressall: (e, data) ->
          progress = parseInt(data.loaded / data.total * 100, 10)
          $('#progress .bar').css('width', progress + '%')
  }
