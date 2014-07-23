## Using YAML

Yaml is a simpler format for data serialization. You can organize your data in **key/value pairs**:

```
likes: "hamburguer"
pizzas_per_month: 2
birth_date: 1986-10-20
```

You can also make lists, like bellow:

```
tv_shows:
  - Game of Thrones
  - The walking dead
other_list: ["foo", "bar", "baz"]
```

Notice the identation above. For any nested data, use identation.
Also prefer using spaces for identing (do not use tabs), 2 spaces is recommended

```
some_data:
  with_nested_field:
    foo: 1
    bar: "baz"
```

For keys, use a snake_case text. Example: instead `"My field"`, use `my_field`

For simple values (not lists or nested key/words), you can use:

  - strings (text between quotes. Ex: "like this")
  - numbers
  - dates (YYYY-MM-DD) .Ex: `2002-12-14`

You can see further information on this link: [YAML](https://en.wikipedia.org/wiki/YAML)
