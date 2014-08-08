LISTENERS = [
  ContributingsListener,
  RelationshipsListener,
]

LISTENERS.each { |listener| EventBus.subscribe(listener.new) }
