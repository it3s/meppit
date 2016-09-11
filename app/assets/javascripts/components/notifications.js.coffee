App.components.notifications = ->
  attributes: ->
    modalId: 'modal:notifications-modal'
    counter: $('.notifications-count')

  initialize: ->
    @toggleCounter()
    App.mediator.subscribe "modal:afterOpen", @onModalOpen.bind(this)
    if @attr.userId
      setInterval @checkNotifications.bind(this), 30000

  onModalOpen: (evt, data) ->
    if data.identifier is @attr.modalId
      @markAsRead()

  checkNotifications: () ->
    $.ajax
      type: 'GET'
      url: "/notifications/count",
      dataType: "json"
      success: (data) => @setCounter(data.count)

  markAsRead: ->
    ids = @unreadIds()
    if ids.length > 0
      $.post @attr.url, {notifications_ids: ids}, (data) => @setCounter 0

  unreadIds: ->
    ids = []
    $('.notifications-list .notification.unread .item').each (idx, el) ->
      ids.push parseInt($(el).data('notification-id'), 10)
    ids

  toggleCounter: ->
    count = parseInt @attr.counter.text(), 10
    visibility = if count > 0 then 'visible' else "hidden"
    @attr.counter.css('visibility', visibility)

  setCounter: (num) ->
    @attr.counter.text(num)
    @toggleCounter()
