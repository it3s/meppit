LISTENERS = [
  ContributingsListener,
]

LISTENERS.each { |listener| EventBus.subscribe(listener.new) }
