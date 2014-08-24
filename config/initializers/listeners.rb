LISTENERS = [
  ContributingsListener,
  RelationshipsListener,
  ActivityListener,
]

LISTENERS.each { |listener| EventBus.subscribe(listener.new) }
