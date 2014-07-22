Rails.application.config.pg_search_options = {
  using: {
    tsearch:    {prefix: true},
    trigram:    {threshold:  0.2},
  }
}

PgSearch.multisearch_options = Rails.application.config.pg_search_options
