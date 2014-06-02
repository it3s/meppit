## Tags

Tags are simply an array column on the model. For indexing
(for autocompletion) we use a concern.


### Using

- Migration: add a postgres array field

```

def change
  change_table :table_name do |t|
    t.string :tags, array: true, default: []
  end
  add_index :table_name, :tags, using: 'gin'
end

```

- On your model add the taggable concern

```
class MyModel << ActiveRecord::Base
  include Taggable

  searchable_tags :tags
end
```

now every time you save this model, the Tags are indexed on the `Tag` model

- For searching

```
Tag.search('term')
```

- Display Tags

```
<%= render shared/tags, :tags => @model.tags %>
```

- Tags input components:

```
<div class="tags">
  <%= tags_input f, :tags, @model.tags %>
</div>
```

### How it works

- The tags are stored on an array column, on the model itself
- We use a table `tags` to only store the tags name, for autocomplete and searching
- For indexing tags use the Taggable concern. He only adds a callback for the
specified field, indexing the saved tags.
- The tags js component uses jquery.tagsinput
- For searching we use the postgres fulltext search engine (with `pg_search`)


