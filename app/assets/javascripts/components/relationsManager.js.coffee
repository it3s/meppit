metadataForm = ->
  {
    template: JST['templates/relationMetadata']

    init: (opts) ->
      @index = opts.index
      @el = $ @template(opts)
      @findFields()
      @status = 'hidden'
      @bindEvents()
      this

    show: ->
      @el.slideDown('fast')
      @status = "active"

    hide: ->
      @el.slideUp('fast')
      @status = "hidden"

    findFields: ->
      @fields = {}
      _.each ['description', 'start_date', 'end_date', 'currency', 'amount'], (key) =>
        @fields[key] = @el.find(".metadata_#{key}")

    onChange: ->
      App.mediator.publish 'relationMetadata:changed', @index

    getValue: ->
      vals = {}
      _.each @fields, (el, key) -> vals[key] = el.val()
      vals

    bindEvents: ->
      _.each @fields, (el, key) =>
        switch key
          when 'description'
            App.mediator.subscribe 'tinymce:changed', (evt, data) =>
              if data.id is el.attr('id')
                el.val data.content
                @onChange()
          when 'amount'
            el.on "change keyup paste", _.debounce(@onChange.bind(this), 100)
          else
            el.change _.debounce(@onChange.bind(this), 100)
  }

relationItem = ->
  {
    template: JST['templates/relationItem']

    init: (opts) ->
      @index = opts.index
      @el = $ @template(opts)
      @addMetadataForm(opts)
      @findElements()
      @bindEvents()
      this

    addMetadataForm: (opts) ->
      @metadata =  metadataForm().init(opts)
      @el.find('.metadata-container').append @metadata.el

    findElements: ->
      @targetEl = @el.find('.relation_target')
      @typeEl   = @el.find('.relation_type')
      @idEl     = @el.find('.relation_id')

    onRemove: (evt) ->
      evt.preventDefault()

      @el.fadeOut 200, =>
        App.mediator.publish 'relationItem:removed', @index
        @el.remove()

    getId: ->
      if @idEl.val().length > 0 then @idEl.val() else null

    getValue: ->
      if @targetEl.val().length > 0 && @typeEl.val().length > 0
        {id: @getId(), target: {id: @targetEl.val()}, type: @typeEl.val(), metadata: @metadata.getValue()}
      else
        null

    setValue: (entry)->
      @targetEl.val(entry.target.id)
      @el.find('.relation_target_autocomplete').val(entry.target.name)
      @typeEl.val(entry.type)
      @idEl.val(entry.id)

    onChange: ->
      App.mediator.publish 'relationItem:changed' if @getValue()

    metadataChanged: (evt, index) ->
      @onChange() if index is @index

    toggleMetadata: (evt)->
      evt.preventDefault()
      if @metadata.status is 'hidden' then @metadata.show() else @metadata.hide()

    bindEvents: ->
      @el.find('.relation-remove-btn').click @onRemove.bind(this)
      @el.find('.relation-metadata-btn').click @toggleMetadata.bind(this)

      @targetEl.change @onChange.bind(this)
      @typeEl.change @onChange.bind(this)

      App.mediator.subscribe 'relationMetadata:changed', @metadataChanged.bind(this)
  }

App.components.relationsManager = (container) ->
  {
    container     : container
    itemsContainer: container.find('.relations-list')
    addButton     : container.find('.add-new-relation')
    relationsInput: container.find('.relations-value')
    items         : []
    counter       : 0

    init: ->
      @data = @container.data 'relationsManager'
      @loadData() if @relationsInput.val().length > 0
      @addItem()  # always show an empty new entry
      @listen()

    loadData: ->
      entries = JSON.parse @relationsInput.val()
      _.each entries, (entry) =>
        item = @addItem()
        item.setValue(entry)

    addItem: ->
      item = relationItem().init _.extend({}, @data, {index: @counter++})
      @items.push item
      @itemsContainer.append(item.el)
      App.mediator.publish 'components:start', item.el
      item

    onAdd: (evt) ->
      evt.preventDefault()
      @addItem()

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
