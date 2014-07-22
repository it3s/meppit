Yaml is a simpler format for data serialization. You can organize your data in simple key/value pairs:

```
likes: "hamburguer"
sport: "rugby"
pizzas_per_month: 2
working_place: "home"
birth_date: 1986-10-20-00:00:00+4
```


You can also make lists, like bellow:

```
tv_shows:
  - Game of Thrones
  - How I met your mother
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
  another: "bla bla bla"
```

For keys use a snake_case text. Example: instead "My field", use **my_field**

For values use:

  - strings (text between quotes "like this")
  - numbers
  - lists
  - nested key/value dat
  - dates (YYYY-MM-DD HH:MM:SS.MS +-Z) .Ex: 2002-12-14  || 2001-12-15 2:59:43.10 || 2001-12-14 21:59:43.10 -5
