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

ActiveRecord::Schema[7.0].define(version: 2023_11_23_024142) do
  create_table "accounts", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", null: false
    t.string "username", null: false
    t.boolean "is_admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest", null: false
    t.string "remember_digest"
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["username"], name: "index_accounts_on_username", unique: true
  end

  create_table "authors", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.text "about", null: false
    t.string "phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_authors_on_name"
  end

  create_table "authors_followers", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "author_id"], name: "index_authors_followers_on_account_id_and_author_id", unique: true
    t.index ["account_id"], name: "index_authors_followers_on_account_id"
    t.index ["author_id"], name: "index_authors_followers_on_author_id"
  end

  create_table "books", charset: "utf8mb4", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.integer "amount", null: false
    t.date "publish_date", null: false
    t.string "isbn", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "publisher_id", null: false
    t.index ["isbn"], name: "index_books_on_isbn", unique: true
    t.index ["publisher_id"], name: "index_books_on_publisher_id"
    t.index ["title"], name: "index_books_on_title", unique: true
  end

  create_table "books_authors", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "author_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_books_authors_on_author_id"
    t.index ["book_id", "author_id"], name: "index_books_authors_on_book_id_and_author_id", unique: true
    t.index ["book_id"], name: "index_books_authors_on_book_id"
  end

  create_table "books_comments", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "account_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_books_comments_on_account_id"
    t.index ["book_id", "account_id"], name: "index_books_comments_on_book_id_and_account_id", unique: true
    t.index ["book_id"], name: "index_books_comments_on_book_id"
  end

  create_table "books_favorites", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_books_favorites_on_account_id"
    t.index ["book_id", "account_id"], name: "index_books_favorites_on_book_id_and_account_id", unique: true
    t.index ["book_id"], name: "index_books_favorites_on_book_id"
  end

  create_table "books_genres", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id", "genre_id"], name: "index_books_genres_on_book_id_and_genre_id", unique: true
    t.index ["book_id"], name: "index_books_genres_on_book_id"
    t.index ["genre_id"], name: "index_books_genres_on_genre_id"
  end

  create_table "books_rates", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "account_id", null: false
    t.integer "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_books_rates_on_account_id"
    t.index ["book_id", "account_id"], name: "index_books_rates_on_book_id_and_account_id", unique: true
    t.index ["book_id"], name: "index_books_rates_on_book_id"
  end

  create_table "borrow_infos", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.integer "status", null: false
    t.integer "remain_turns", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_borrow_infos_on_account_id"
    t.index ["end_at"], name: "index_borrow_infos_on_end_at"
    t.index ["start_at"], name: "index_borrow_infos_on_start_at"
  end

  create_table "borrow_responses", charset: "utf8mb4", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "borrow_info_id", null: false
    t.index ["borrow_info_id"], name: "index_borrow_responses_on_borrow_info_id"
  end

  create_table "borrowed_items", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "borrow_info_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id", "borrow_info_id"], name: "index_borrowed_items_on_book_id_and_borrow_info_id", unique: true
    t.index ["book_id"], name: "index_borrowed_items_on_book_id"
    t.index ["borrow_info_id"], name: "index_borrowed_items_on_borrow_info_id"
  end

  create_table "genres", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true
  end

  create_table "publishers", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.text "about", null: false
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_publishers_on_name"
  end

  create_table "user_infos", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.integer "gender", null: false
    t.string "address", null: false
    t.string "phone", null: false
    t.string "citizen_id", null: false
    t.date "dob"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_user_infos_on_account_id"
    t.index ["address"], name: "index_user_infos_on_address"
    t.index ["citizen_id"], name: "index_user_infos_on_citizen_id", unique: true
    t.index ["name"], name: "index_user_infos_on_name"
    t.index ["phone"], name: "index_user_infos_on_phone"
  end

  add_foreign_key "authors_followers", "accounts"
  add_foreign_key "authors_followers", "authors"
  add_foreign_key "books", "publishers"
  add_foreign_key "books_authors", "authors"
  add_foreign_key "books_authors", "books"
  add_foreign_key "books_comments", "accounts"
  add_foreign_key "books_comments", "books"
  add_foreign_key "books_favorites", "accounts"
  add_foreign_key "books_favorites", "books"
  add_foreign_key "books_genres", "books"
  add_foreign_key "books_genres", "genres"
  add_foreign_key "books_rates", "accounts"
  add_foreign_key "books_rates", "books"
  add_foreign_key "borrow_infos", "accounts"
  add_foreign_key "borrow_responses", "borrow_infos"
  add_foreign_key "borrowed_items", "books"
  add_foreign_key "borrowed_items", "borrow_infos"
  add_foreign_key "user_infos", "accounts"
end
