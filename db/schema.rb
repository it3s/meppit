# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141029135041) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"
  enable_extension "postgis"
  enable_extension "pg_trgm"
  enable_extension "fuzzystrmatch"

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], :name => "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], :name => "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], :name => "index_activities_on_trackable_id_and_trackable_type"

  create_table "authentications", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.integer  "user_id",      null: false
    t.integer  "content_id",   null: false
    t.string   "content_type", null: false
    t.text     "comment",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["content_id", "content_type"], :name => "index_comments_on_content_id_and_content_type"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "contributings", force: true do |t|
    t.integer  "contributor_id"
    t.integer  "contributable_id"
    t.string   "contributable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contributings", ["contributable_id", "contributable_type"], :name => "index_contributings_on_contributable_id_and_contributable_type"
  add_index "contributings", ["contributor_id"], :name => "index_contributings_on_contributor_id"

  create_table "featureds", force: true do |t|
    t.integer  "featurable_id"
    t.string   "featurable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "featureds", ["featurable_id", "featurable_type"], :name => "index_featureds_on_featurable_id_and_featurable_type"

  create_table "followings", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followable_id"
    t.string   "followable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followings", ["followable_type", "followable_id"], :name => "index_followings_on_followable_type_and_followable_id"
  add_index "followings", ["follower_id"], :name => "index_followings_on_follower_id"

  create_table "geo_data", force: true do |t|
    t.string   "name",                                                                     null: false
    t.text     "description"
    t.hstore   "contacts"
    t.text     "tags",                                                     default: [],                 array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "location",        limit: {:srid=>4326, :type=>"geometry"}
    t.json     "additional_info"
    t.boolean  "is_featured",                                              default: false, null: false
  end

  add_index "geo_data", ["is_featured"], :name => "index_geo_data_on_is_featured"
  add_index "geo_data", ["location"], :name => "index_geo_data_on_location", :spatial => true
  add_index "geo_data", ["tags"], :name => "index_geo_data_on_tags"

  create_table "imports", force: true do |t|
    t.string   "source",                            null: false
    t.integer  "user_id",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "imported",          default: false
    t.text     "imported_data_ids", default: [],                 array: true
    t.integer  "map_id"
  end

  add_index "imports", ["map_id"], :name => "index_imports_on_map_id"
  add_index "imports", ["user_id"], :name => "index_imports_on_user_id"

  create_table "layers", force: true do |t|
    t.string   "name"
    t.integer  "position"
    t.boolean  "visible"
    t.string   "fill_color",   limit: 10
    t.string   "stroke_color", limit: 10
    t.hstore   "rule"
    t.integer  "map_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "layers", ["map_id"], :name => "index_layers_on_map_id"

  create_table "mappings", force: true do |t|
    t.integer  "geo_data_id", null: false
    t.integer  "map_id",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mappings", ["geo_data_id"], :name => "index_mappings_on_geo_data_id"
  add_index "mappings", ["map_id"], :name => "index_mappings_on_map_id"

  create_table "maps", force: true do |t|
    t.string   "name",                             null: false
    t.text     "description"
    t.hstore   "contacts"
    t.text     "tags",             default: [],                 array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "administrator_id",                 null: false
    t.json     "additional_info"
    t.boolean  "is_featured",      default: false, null: false
  end

  add_index "maps", ["administrator_id"], :name => "index_maps_on_administrator_id"
  add_index "maps", ["is_featured"], :name => "index_maps_on_is_featured"
  add_index "maps", ["tags"], :name => "index_maps_on_tags"

  create_table "notifications", force: true do |t|
    t.integer  "user_id",                        null: false
    t.integer  "activity_id",                    null: false
    t.string   "status",      default: "unread", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  create_table "pg_search_documents", force: true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", force: true do |t|
    t.string   "image",        null: false
    t.integer  "author_id",    null: false
    t.integer  "content_id"
    t.string   "content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  add_index "pictures", ["author_id"], :name => "index_pictures_on_author_id"
  add_index "pictures", ["content_id", "content_type"], :name => "index_pictures_on_content_id_and_content_type"

  create_table "relation_metadata", force: true do |t|
    t.integer  "relation_id"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.float    "amount"
    t.string   "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relation_metadata", ["relation_id"], :name => "index_relation_metadata_on_relation_id"

  create_table "relations", force: true do |t|
    t.text     "related_ids", default: [], null: false, array: true
    t.string   "rel_type",                 null: false
    t.string   "direction",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relations", ["related_ids"], :name => "index_relations_on_related_ids"

  create_table "tags", force: true do |t|
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name",                                                                                       null: false
    t.string   "email",                                                                                      null: false
    t.string   "crypted_password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.string   "language",                        limit: 10
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.text     "about_me"
    t.hstore   "contacts"
    t.string   "avatar"
    t.spatial  "location",                        limit: {:srid=>4326, :type=>"geometry"}
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.text     "interests",                                                                default: [],                   array: true
    t.string   "auth_token"
    t.string   "mail_notifications",                                                       default: "daily"
  end

  add_index "users", ["activation_token"], :name => "index_users_on_activation_token"
  add_index "users", ["auth_token"], :name => "index_users_on_auth_token"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["interests"], :name => "index_users_on_interests"
  add_index "users", ["location"], :name => "index_users_on_location", :spatial => true
  add_index "users", ["remember_me_token"], :name => "index_users_on_remember_me_token"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token"

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.text     "object_changes"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
