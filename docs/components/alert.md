## Alert

Its a simple 'notification' or flash message on the upside right corner.

Whenever you use a Rails native `flash` message it will display as an alert.

### Markup

```
<div class="alert alert-info" data-components="alert">
  <a class="close">&#215;</a>
  <%= raw msg %>
</div>
```

For styling use:

```
.alert-info
.alert-warn
.alert-error
```
