relationItem = ->
  {
    template: """
     <div class="relation-item" data-rel-index="<%= index %>">

        <select name="geo_data[relations][<%= index%>][type]" data-components="chosen" data-placeholder="<%= type_placeholder %>" >
          <% _.each(options, function(opt) { %>
            <option value="<%= opt[1] %>"><%= opt[0] %></option>
          <% }); %>
        </select>

        <input type="hidden" name="geo_data[relations][<%= index%>][target]" id="relation_target_<%= index %>-autocomplete"/>
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
      this
  }

App.components.relationsManager = (container) ->
  {
    container     : container
    addButton     : container.find('.add-new-relation')
    relationsInput: container.find('.relations-value')
    items         : []

    init: ->
      @data = @container.data 'relationsManager'
      @listen()

    onAdd: (evt) ->
      evt.preventDefault()
      item = relationItem().init _.extend({}, @data, {index: @items.length})
      @items.push item
      @container.append(item.el)
      App.mediator.publish 'components:start', item.el

    listen: ->
      @addButton.click @onAdd.bind(this)


  }
