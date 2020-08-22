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

ActiveRecord::Schema.define(version: 202008150430225) do

  create_table "comment_favorites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "shop_id", null: false
    t.bigint "comment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_comment_favorites_on_comment_id"
    t.index ["user_id"], name: "index_comment_favorites_on_user_id"
  end

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_name", null: false
    t.string "shop_id", null: false
    t.string "comment", null: false
    t.string "image"
    t.bigint "logged_shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["logged_shop_id"], name: "index_comments_on_logged_shop_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "favorites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "shop_id", null: false
    t.bigint "logged_shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["logged_shop_id"], name: "index_favorites_on_logged_shop_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "follow_relationships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "following_user_id", null: false
    t.boolean "is_mutual_follow", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["following_user_id"], name: "index_follow_relationships_on_following_user_id"
    t.index ["user_id"], name: "index_follow_relationships_on_user_id"
  end

  create_table "logged_shops", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "action_from", null: false
    t.string "shop_id", null: false
    t.string "lat"
    t.string "lng"
    t.string "name"
    t.string "catch"
    t.string "capacity"
    t.string "photo"
    t.string "budget"
    t.string "budget_memo"
    t.string "mobile_access"
    t.string "open"
    t.string "non_smoking"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_logged_shops_on_user_id"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "to_user_id", null: false
    t.string "title", null: false
    t.string "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["to_user_id"], name: "index_messages_on_to_user_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "shop_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "shop_id", null: false
    t.string "tag", null: false
    t.bigint "logged_shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["logged_shop_id"], name: "index_shop_tags_on_logged_shop_id"
  end

  create_table "user_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "tag", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_tags_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "uid", null: false
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "visited_shops", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "shop_id", null: false
    t.bigint "logged_shop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["logged_shop_id"], name: "index_visited_shops_on_logged_shop_id"
    t.index ["user_id"], name: "index_visited_shops_on_user_id"
  end

  add_foreign_key "comment_favorites", "comments", on_delete: :cascade
  add_foreign_key "comment_favorites", "users", on_delete: :cascade
  add_foreign_key "comments", "logged_shops", on_delete: :cascade
  add_foreign_key "comments", "users", on_delete: :cascade
  add_foreign_key "favorites", "logged_shops", on_delete: :cascade
  add_foreign_key "favorites", "users", on_delete: :cascade
  add_foreign_key "follow_relationships", "users", column: "following_user_id", on_delete: :cascade
  add_foreign_key "follow_relationships", "users", on_delete: :cascade
  add_foreign_key "logged_shops", "users", on_delete: :cascade
  add_foreign_key "messages", "users", column: "to_user_id", on_delete: :cascade
  add_foreign_key "messages", "users", on_delete: :cascade
  add_foreign_key "shop_tags", "logged_shops", on_delete: :cascade
  add_foreign_key "user_tags", "users", on_delete: :cascade
  add_foreign_key "visited_shops", "logged_shops", on_delete: :cascade
  add_foreign_key "visited_shops", "users", on_delete: :cascade
end
