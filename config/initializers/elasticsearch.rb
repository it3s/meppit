
if Rails.env.test? || Rails.env.development?
  ENV["ELASTICSEARCH_URL"] = "http://0.0.0.0:9200"
end
