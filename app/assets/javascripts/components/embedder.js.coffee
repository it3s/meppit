App.components.embedder = ->
  attributes: ->
    optionsEl: @container.find('.options')
    codeInput: @container.find('#embed-code')

  initialize: ->
    @options =
      width:  800
      height: 450
      style:  "border:none;"

    @populateCodeArea()

  url: ->
    "#{@attr.baseUrl}"

  code: ->
    "<iframe src=\"#{@url()}\" width=\"#{@options.width}\" height=\"#{@options.height}\" style=\"#{@options.style}\"></iframe>"

  populateCodeArea : ->
    @attr.codeInput.val @code()
