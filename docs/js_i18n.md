## Js translations

All js translations live inside `config/locales/<lang>/js.yml`.

E.g:

a translation file:

```
en:
  js:
    bla:
      ble: "An string"
```

and for using:

```
I18n.bla.bla # => "An string"
```

OBS: for now, we dont contemplate complex string definition, with interpolations, pluralization and etc.
If necessary we may add that, but for now, we want to keep as simple as possible.
