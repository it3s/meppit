relationItem = ->
  {
    template: """
      <div class="relation-item" data-rel-index="<%= index %>">

        <select name="relations_type_<%= index%>" class="relation_type" >
          <option value=""> </option>
          <% _.each(options, function(opt) { %>
            <option value="<%= opt[1] %>"><%= opt[0] %></option>
          <% }); %>
        </select>

        <input type="hidden" name="relations_target_<%= index%>" class="relation_target"
            id="relation_target_<%= index %>-autocomplete"/>
        <input type="text" class="relation_target_autocomplete" placeholder="<%= autocomplete_placeholder %>"
            data-components="autocomplete"
            data-component-options='{"name":"relation_target_<%= index %>","url":"<%= autocomplete_url %>"}' />

        <a href="#" class="relation-metadata" title="<%= metadata_title %>"><i class="fa fa-plus"></i></a>
        <a href="#" class="relation-remove" title="<%= remove_title %>"><i class="fa fa-trash-o"></i></a>

      </div>
    """

    init: (opts) ->
      @index = opts.index
      @el = $(_.template @template, opts)
      @targetEl = @el.find('.relation_target')
      @typeEl   = @el.find('.relation_type')
      @bindEvents()
      this

    onRemove: (evt) ->
      evt.preventDefault()

      @el.fadeOut 100, =>
        App.mediator.publish 'relationItem:removed', @index
        @el.remove()

    getValue: ->
      if @targetEl.val().length > 0 && @typeEl.val().length > 0
        {target: @targetEl.val(), type: @typeEl.val()}
      else
        null

    onChange: ->
      App.mediator.publish 'relationItem:changed' if @getValue()

    bindEvents: ->
      @el.find('.relation-remove').click @onRemove.bind(this)

      @targetEl.change @onChange.bind(this)
      @typeEl.change @onChange.bind(this)
  }

App.components.relationsManager = (container) ->
  {
    container     : container
    addButton     : container.find('.add-new-relation')
    relationsInput: container.find('.relations-value')
    items         : []

    init: ->
      @data = @container.data 'relationsManager'
      @counter = 0
      @listen()

    onAdd: (evt) ->
      evt.preventDefault()
      item = relationItem().init _.extend({}, @data, {index: @counter++})
      @items.push item
      @container.append(item.el)
      App.mediator.publish 'components:start', item.el

    onRemove: (evt, index) ->
      @items[index] = null
      @onChange()

    onChange: ->
      vals = []
      _.each @items, (item) ->
        vals.push item.getValue() if item && item.getValue()
      @relationsInput.val JSON.stringify(vals)

    listen: ->
      @addButton.click @onAdd.bind(this)
      App.mediator.subscribe 'relationItem:removed', @onRemove.bind(this)
      App.mediator.subscribe 'relationItem:changed', @onChange.bind(this)

  }
