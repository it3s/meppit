expanded = """
<i class="fa fa-chevron-up"></i> #{I18n.lists.collapse}
"""
collapsed = """
<i class="fa fa-chevron-down"></i> #{I18n.lists.expand}
"""

App.components.listFilter = ->
  attributes: ->
    toggleBtn:   @container.find('.toggle-panel')
    filtersForm: @container.find('.filters')

  initialize: ->
    @on @attr.toggleBtn, 'click', @toggle

  toggle: ->
    if @isExpanded() then @collapse() else @expand()

  isExpanded: ->
    @attr.toggleBtn.data('toggle') is 'expanded'

  collapse: ->
    @attr.filtersForm.slideUp('fast')
    @attr.toggleBtn.data('toggle', 'collapsed')
    @attr.toggleBtn.html collapsed

  expand: ->
    @attr.filtersForm.slideDown('fast')
    @attr.toggleBtn.data('toggle', 'expanded')
    @attr.toggleBtn.html expanded
