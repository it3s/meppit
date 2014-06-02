## Tags

tags editor, using the jquery.tagsinput plugin

### Markup

```
<div class="tags">
  <%= tags_input f, :tags, @model.tags %>
</div>
```

- `f` is a simple_form builder.
- the 2nd argument is the field name
- 3rd argument is the tags array

For styling just wrapp on a `.tags` div

