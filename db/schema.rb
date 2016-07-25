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

ActiveRecord::Schema.define(version: 20160420190818) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "bron_tickets", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "seat_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "closed_by"
    t.integer  "opened_by"
    t.string   "fullName"
    t.datetime "expiry_date"
    t.integer  "seat_sector_id"
  end

  create_table "cashier_logs", force: :cascade do |t|
    t.integer  "cashier_id"
    t.string   "action"
    t.datetime "datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cashiers", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "sell"
    t.boolean  "bron"
    t.boolean  "invitation"
    t.boolean  "discount"
    t.string   "name"
    t.string   "surname"
    t.boolean  "unsell"
  end

  add_index "cashiers", ["email"], name: "index_cashiers_on_email", unique: true, using: :btree
  add_index "cashiers", ["reset_password_token"], name: "index_cashiers_on_reset_password_token", unique: true, using: :btree

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "colors", force: :cascade do |t|
    t.string   "name"
    t.string   "class_name"
    t.string   "identificator"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "competition_translations", force: :cascade do |t|
    t.integer  "competition_id", null: false
    t.string   "locale",         null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "name"
    t.text     "program"
  end

  add_index "competition_translations", ["competition_id"], name: "index_competition_translations_on_competition_id", using: :btree
  add_index "competition_translations", ["locale"], name: "index_competition_translations_on_locale", using: :btree

  create_table "competitions", force: :cascade do |t|
    t.string   "name"
    t.string   "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "datetime"
    t.boolean  "IsActive"
    t.text     "program"
  end

  create_table "entrances", force: :cascade do |t|
    t.integer  "sector_id"
    t.integer  "event_id"
    t.string   "entrance_text"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "datetime"
    t.string   "description"
    t.string   "image_url"
    t.integer  "competition_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "program"
    t.boolean  "IsActive"
    t.text     "ticketimage"
    t.string   "sectors"
  end

  create_table "h_in_out_registers", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "in_out"
    t.datetime "last_in_out_date"
    t.string   "seat_id"
  end

  create_table "intervals", force: :cascade do |t|
    t.integer  "cashier_id"
    t.integer  "from"
    t.integer  "to"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "interval_number"
    t.boolean  "active"
    t.integer  "event_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "cashier_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "event_id"
  end

  create_table "online_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "online_users", ["confirmation_token"], name: "index_online_users_on_confirmation_token", unique: true, using: :btree
  add_index "online_users", ["email"], name: "index_online_users_on_email", unique: true, using: :btree
  add_index "online_users", ["reset_password_token"], name: "index_online_users_on_reset_password_token", unique: true, using: :btree

  create_table "seats", force: :cascade do |t|
    t.integer  "sector_id"
    t.integer  "row"
    t.integer  "column"
    t.string   "real_sector_id"
    t.string   "real_row"
    t.string   "real_column"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "sectors", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "selected_places", force: :cascade do |t|
    t.integer  "cashier_id"
    t.integer  "event_id"
    t.string   "seat_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "seat_sector_id"
  end

  create_table "selling_seats", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "seat_id"
    t.integer  "color_id"
    t.float    "price"
    t.integer  "ticket_type_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "ticket_items", force: :cascade do |t|
    t.integer  "event_id"
    t.string   "seat_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.integer  "cashier_id"
    t.integer  "invoice_id"
    t.boolean  "is_invalid",                              default: false
    t.integer  "interval_number"
    t.string   "entrance"
    t.string   "sector"
    t.string   "row"
    t.string   "column"
    t.string   "ticket_type"
    t.string   "ticket_image"
    t.integer  "seat_sector_id"
    t.decimal  "price",           precision: 5, scale: 2
    t.decimal  "real_price",      precision: 5, scale: 2
  end

  create_table "ticket_types", force: :cascade do |t|
    t.string   "name"
    t.string   "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
