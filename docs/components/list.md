## List

list of objects using infinite scroll (uses infinite-scroll)

### Markup

```
<div data-components="list" data-list='{"options": "goes here"}'>
  <%= paginate @collection, :remote => true %>
  <ul class="list">
    <%= render @collection %>
  </ul>
</div>
```

### Options
```
:scroll => default undefined  # infinite-scroll options
```
