LISTENERS = [
  ContributingsListener,
  RelationshipsListener,
  ActivityListener,
  LayersListener
]

LISTENERS.each { |listener| EventBus.subscribe(listener.new) }
