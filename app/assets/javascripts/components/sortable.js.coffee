#= require jquery-ui/sortable

App.components.sortable = ->
  initialize: ->
      @container.sortable().disableSelection()
