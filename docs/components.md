## Js Components

For adding any js behavior we use an "auto-loading component" pattern.

We have a global `App.mediator` pub/sub object. So always use async events to coordinate behavior among components.

When a event "components:start" is triggered (passing an optional root node), all components on that root tree will be loaded.

### App.mediator

```
publish(channel, data)  # emit an event with the given data
subscribe(channel, fn)  # subscribe to the given channel, and call the callback function (which receives data)
unsubscribe(channel)    # stop listening to that channel
```

### App.components

```
App.components._instances  # an hash which holds all started components instances, the key is either the container id or a 'random' generated id
App.components             # object with the component factories
```


## Creating a component

### markup

A component is an html container with a `data-components` attributes. The components refered on this attr, will be initialized for that container. E.g:

```
<div id="my-ui-component" data-components="component1 component2" ></div>

# will call the factories for component1 and component2 passing the #my-ui-component container as argument
```

### js

An js component is a factory with the following structure:

```
App.components.component1 = (container)->
  container: container

  init: ->
     # this is the initialization function, called when the component is started

  # ... any methods you want

```

For passing data for the component use the `data` atrributes. I.e:

```
<div data-components="my_component" data-my_component='<%= {:key1 => "value" }.to_json %>'></div>

App.components.my_component = (container) ->
  container: container

  init: ->
    data = @container.data('my_component');
    console.log data # js object with the given data

```

## Remarks

- add an asset-pipeline dependencie for (only) an component, on its own file. E.g:

```
# uploader.js.coffee

#= require 'jquery-fileupload'

App.components.uploader = (container) -> ...
```

- avoid 'class', 'new' and mutating state, as much as possible. Try to write a more "functional" javascript, always use small functions and message passing. For creating objects use a factory pattern (like you saw on components).


