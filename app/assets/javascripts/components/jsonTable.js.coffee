#= require json.human

App.components.jsonTable = (container) ->
  {
    container: container

    init: ->
      @data = @container.data('component-jsontable')
      @loadTable()

    loadTable: ->
      table = JsonHuman.format(@data)
      @container.append table
  }

