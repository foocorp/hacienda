class CreateDatabaseStructure < ActiveRecord::Migration[7.1]
  def change
    create_table :database_structures do |t|

      t.timestamps
    end
  end
  def up
    # This file is auto-generated from the current state of the database. Instead
    # of editing this file, please use the migrations feature of Active Record to
    # incrementally modify your database, and then regenerate this schema definition.
    #
    # This file is the source Rails uses to define your schema when running `bin/rails
    # db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
    # be faster and is potentially less error prone than running all of your
    # migrations from scratch. Old migrations may fail to apply correctly if those
    # migrations use external dependencies or application code.
    #
    # It's strongly recommended that you check this file into your version control system.
    
    ActiveRecord::Schema[7.1].define(version: 0) do
      # These are extensions that must be enabled in order to support this database
      enable_extension "plpgsql"
    
      create_table "accountactivation", id: false, force: :cascade do |t|
        t.string "username", limit: 64
        t.string "authcode", limit: 32
        t.integer "expires"
      end
    
      create_table "album", id: :serial, force: :cascade do |t|
        t.string "name", limit: 255, default: "", null: false
        t.string "artist_name", limit: 255, default: "", null: false
        t.string "mbid", limit: 36
        t.integer "releasedate"
        t.string "albumurl", limit: 255
        t.string "image", limit: 255
        t.string "artwork_license", limit: 255
        t.string "downloadurl", limit: 255
        t.index "lower((artist_name)::text)", name: "album_artist_name_idx"
        t.index "lower((name)::text)", name: "album_album_name_idx"
        t.index ["name"], name: "album_name_idx"
      end
    
      create_table "artist", id: :serial, force: :cascade do |t|
        t.string "name", limit: 255, null: false
        t.string "mbid", limit: 36
        t.integer "streamable"
        t.integer "bio_published"
        t.text "bio_content"
        t.text "bio_summary"
        t.string "image_small", limit: 255
        t.string "image_medium", limit: 255
        t.string "image_large", limit: 255
        t.string "homepage", limit: 255
        t.integer "imbid"
        t.string "origin", limit: 255
        t.string "hashtag", limit: 255
        t.string "flattr_uid", limit: 255
        t.index "lower((name)::text)", name: "aritst_name_idx"
        t.index ["name"], name: "artist_name_idx"
      end
    
      create_table "artist_bio", id: false, force: :cascade do |t|
        t.integer "artist"
        t.text "bio"
      end
    
      create_table "auth", primary_key: "token", id: { type: :string, limit: 32 }, force: :cascade do |t|
        t.string "sk", limit: 32
        t.integer "expires"
        t.string "username", limit: 64
      end
    
      create_table "banned_tracks", id: false, force: :cascade do |t|
        t.integer "userid"
        t.string "track", limit: 255
        t.string "artist", limit: 255
        t.integer "time"
    
        t.unique_constraint ["userid", "track", "artist"], name: "banned_tracks_userid_key"
      end
    
      create_table "clientcodes", primary_key: "code", id: { type: :string, limit: 3, default: "" }, force: :cascade do |t|
        t.string "name", limit: 32
        t.string "url", limit: 256
        t.string "free", limit: 1, default: "N"
      end
    
      create_table "countries", primary_key: "country", id: { type: :string, limit: 2 }, force: :cascade do |t|
        t.string "country_name", limit: 200
        t.string "wikipedia_en", limit: 120
      end
    
      create_table "delete_request", primary_key: "code", id: { type: :string, limit: 300 }, force: :cascade do |t|
        t.integer "expires"
        t.string "username", limit: 64
      end
    
      create_table "domain_blacklist", primary_key: "domain", id: :text, force: :cascade do |t|
        t.integer "expires"
      end
    
      create_table "error", id: :serial, force: :cascade do |t|
        t.text "msg"
        t.text "data"
        t.integer "time"
      end
    
      create_table "group_members", primary_key: ["grp", "member"], force: :cascade do |t|
        t.integer "joined", null: false
        t.integer "grp", null: false
        t.integer "member", null: false
      end
    
      create_table "groups", id: :serial, force: :cascade do |t|
        t.string "groupname", limit: 64, null: false
        t.string "fullname", limit: 255
        t.text "bio"
        t.string "homepage", limit: 255
        t.integer "created", null: false
        t.integer "modified"
        t.string "avatar_uri", limit: 255
        t.integer "grouptype"
        t.integer "owner"
        t.index "lower((groupname)::text)", name: "groups_groupname_idx", unique: true
      end
    
      create_table "invitation_request", primary_key: "email", id: { type: :string, limit: 255 }, force: :cascade do |t|
        t.integer "time"
        t.integer "status", default: 0
      end
    
      create_table "invitations", primary_key: ["inviter", "invitee", "code"], force: :cascade do |t|
        t.string "inviter", limit: 64, default: "", null: false
        t.string "invitee", limit: 64, default: "", null: false
        t.string "code", limit: 32, default: "", null: false
      end
    
      create_table "loved_tracks", id: false, force: :cascade do |t|
        t.integer "userid"
        t.string "track", limit: 255
        t.string "artist", limit: 255
        t.integer "time"
    
        t.unique_constraint ["userid", "track", "artist"], name: "loved_tracks_userid_key"
      end
    
      create_table "manages", id: false, force: :cascade do |t|
        t.integer "userid"
        t.string "artist", limit: 255
        t.integer "authorised"
      end
    
      create_table "now_playing", primary_key: "sessionid", id: { type: :string, limit: 32 }, force: :cascade do |t|
        t.string "track", limit: 255
        t.string "artist", limit: 255
        t.integer "expires"
        t.string "mbid", limit: 36
        t.string "album", limit: 255
      end
    
      create_table "places", primary_key: "location_uri", id: { type: :string, limit: 255 }, force: :cascade do |t|
        t.float "latitude"
        t.float "longitude"
        t.string "country", limit: 2
      end
    
      create_table "radio_sessions", primary_key: ["username", "session"], force: :cascade do |t|
        t.string "username", limit: 64, default: "", null: false
        t.string "session", limit: 32, default: "", null: false
        t.string "url", limit: 255
        t.integer "expires", default: 0, null: false
      end
    
      create_table "recovery_request", primary_key: "username", id: { type: :string, limit: 64 }, force: :cascade do |t|
        t.string "email", limit: 255
        t.string "code", limit: 32
        t.integer "expires"
      end
    
      create_table "relationship_flags", primary_key: "flag", id: { type: :string, limit: 12 }, force: :cascade do |t|
      end
    
      create_table "scrobble_sessions", primary_key: "sessionid", id: { type: :string, limit: 32, default: "" }, force: :cascade do |t|
        t.integer "expires"
        t.string "client", limit: 3
        t.integer "userid"
        t.string "api_key", limit: 32
      end
    
      create_table "scrobble_track", id: :serial, force: :cascade do |t|
        t.string "artist", limit: 255, null: false
        t.string "album", limit: 255
        t.string "name", limit: 255, null: false
        t.string "mbid", limit: 36
        t.integer "track", null: false
        t.index ["album"], name: "scrobble_track_album_idx"
        t.index ["artist"], name: "scrobble_track_artist_idx"
        t.index ["mbid"], name: "scrobble_track_mbid_idx"
        t.index ["name"], name: "scrobble_track_name_idx"
        t.index ["track"], name: "scrobble_track_track_idx"
      end
    
      create_table "scrobbles", id: false, force: :cascade do |t|
        t.string "track", limit: 255, default: "", null: false
        t.string "artist", limit: 255, default: "", null: false
        t.integer "time", default: 0, null: false
        t.string "mbid", limit: 36
        t.string "album", limit: 255
        t.string "source", limit: 6
        t.string "rating", limit: 1
        t.integer "length"
        t.integer "stid"
        t.integer "userid", null: false
        t.tsvector "track_tsv"
        t.tsvector "artist_tsv"
        t.index "lower((artist)::text)", name: "scrobbles_artist_idx"
        t.index "lower((track)::text)", name: "scrobbles_track_idx"
        t.index ["artist", "track"], name: "scrobbles_artist_track_idx"
        t.index ["artist"], name: "scrobbles_Artist_idx"
        t.index ["artist_tsv"], name: "scrobbles_artist_tsv", using: :gin
        t.index ["stid"], name: "scrobbles_stid_idx"
        t.index ["time"], name: "scrobbles_time_desc_idx", order: :desc
        t.index ["track_tsv"], name: "scrobbles_track_tsv", using: :gin
        t.index ["userid", "artist"], name: "scrobbles_userid_artist_idx"
        t.index ["userid", "time"], name: "scrobbles_userid_time_desc_idx", order: { time: :desc }
        t.index ["userid", "time"], name: "scrobbles_userid_time_idx"
        t.index ["userid"], name: "scrobbles_userid_idx"
      end
    
      create_table "service_connections", id: false, force: :cascade do |t|
        t.integer "userid"
        t.string "webservice_url", limit: 255
        t.string "remote_key", limit: 255
        t.string "remote_username", limit: 255
        t.integer "forward", default: 1
      end
    
      create_table "similar_artist", primary_key: ["name_a", "name_b"], force: :cascade do |t|
        t.string "name_a", limit: 255, default: "", null: false
        t.string "name_b", limit: 255, default: "", null: false
      end
    
      create_table "tags", id: false, force: :cascade do |t|
        t.string "tag", limit: 64, default: "", null: false
        t.string "artist", limit: 255, default: "", null: false
        t.string "album", limit: 255, default: "", null: false
        t.string "track", limit: 255, default: "", null: false
        t.integer "userid"
        t.index ["album"], name: "tags_album_idx"
        t.index ["artist"], name: "tags_artist_idx"
        t.index ["tag"], name: "tags_tag_idx"
        t.index ["track"], name: "tags_track_idx"
        t.unique_constraint ["tag", "artist", "album", "track", "userid"], name: "tags_artist_album_track_userid_key"
      end
    
      create_table "track", id: :serial, force: :cascade do |t|
        t.string "name", limit: 255, default: "", null: false
        t.string "artist_name", limit: 255, default: "", null: false
        t.string "album_name", limit: 255
        t.string "mbid", limit: 36
        t.integer "duration"
        t.integer "streamable", default: 0
        t.string "license", limit: 255
        t.string "downloadurl", limit: 255
        t.string "streamurl", limit: 255
        t.string "otherid", limit: 16
        t.index "lower((album_name)::text)", name: "track_album_idx"
        t.index "lower((artist_name)::text)", name: "track_artist_idx"
        t.index "lower((name)::text)", name: "track_name_idx"
        t.index ["album_name"], name: "track_Album_idx"
        t.index ["artist_name"], name: "track_artist_idx2"
        t.index ["name", "album_name", "artist_name"], name: "track_name_album_artist_idx"
        t.index ["streamable"], name: "track_streamable_idx"
      end
    
      create_table "user_relationship_flags", primary_key: ["uid1", "uid2", "flag"], force: :cascade do |t|
        t.integer "uid1", null: false
        t.integer "uid2", null: false
        t.string "flag", limit: 12, null: false
      end
    
      create_table "user_relationships", primary_key: ["uid1", "uid2"], force: :cascade do |t|
        t.integer "uid1", null: false
        t.integer "uid2", null: false
        t.integer "established", null: false
      end
    
      create_table "user_stats", primary_key: "userid", id: :integer, default: nil, force: :cascade do |t|
        t.integer "scrobble_count", null: false
      end
    
      create_table "users", primary_key: "uniqueid", id: :serial, force: :cascade do |t|
        t.string "username", limit: 64, null: false
        t.string "password", limit: 32, null: false
        t.string "email", limit: 255
        t.string "fullname", limit: 255
        t.text "bio"
        t.string "homepage", limit: 255
        t.string "location", limit: 255
        t.integer "created"
        t.integer "modified"
        t.integer "userlevel", default: 0
        t.string "webid_uri", limit: 255
        t.string "avatar_uri", limit: 255
        t.string "location_uri", limit: 255
        t.integer "active", default: 1
        t.string "laconica_profile", limit: 255
        t.string "journal_rss", limit: 255
        t.integer "anticommercial", default: 0
        t.integer "public_export", default: 0
        t.string "openid_url", limit: 100
        t.integer "receive_emails", default: 1
        t.index "lower((username)::text)", name: "users_uniq_idx", unique: true
        t.timestamps
      end
    
      add_foreign_key "artist_bio", "artist", column: "artist", name: "artist_bio_artist_fkey"
      add_foreign_key "now_playing", "scrobble_sessions", column: "sessionid", primary_key: "sessionid", name: "now_playing_sessionid_fkey", on_delete: :cascade
      add_foreign_key "scrobble_sessions", "users", column: "userid", primary_key: "uniqueid", name: "scrobble_sessions_userid_fkey"
      add_foreign_key "scrobbles", "users", column: "userid", primary_key: "uniqueid", name: "scrobbles_userid_fkey"
      add_foreign_key "service_connections", "users", column: "userid", primary_key: "uniqueid", name: "service_connections_userid_fkey"
      add_foreign_key "user_relationship_flags", "relationship_flags", column: "flag", primary_key: "flag", name: "user_relationship_flags_flag_fkey"
      add_foreign_key "user_relationship_flags", "user_relationships", column: ["uid1", "uid2"], primary_key: ["uid1", "uid2"], name: "user_relationship_flags_uid1_fkey"
      add_foreign_key "user_relationships", "users", column: "uid1", primary_key: "uniqueid", name: "user_relationships_uid1_fkey", on_delete: :cascade
      add_foreign_key "user_relationships", "users", column: "uid2", primary_key: "uniqueid", name: "user_relationships_uid2_fkey", on_delete: :cascade
      add_foreign_key "user_stats", "users", column: "userid", primary_key: "uniqueid", name: "user_stats_userid_fkey", on_delete: :cascade
    end
  end
end
