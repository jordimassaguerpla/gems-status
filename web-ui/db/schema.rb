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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130204000642) do

  create_table "checker_types", :force => true do |t|
    t.string   "name"
    t.string   "desc"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "gem_checker_results", :force => true do |t|
    t.integer  "gem_info_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "check_result"
    t.integer  "checker_type_id"
  end

  create_table "gem_info_rails_apps", :force => true do |t|
    t.integer  "gem_info_id"
    t.integer  "rails_app_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "gem_infos", :force => true do |t|
    t.string   "name"
    t.string   "version"
    t.string   "md5sum"
    t.string   "source"
    t.string   "gem_server"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "license"
  end

  create_table "rails_apps", :force => true do |t|
    t.string   "name"
    t.string   "gemfile"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "desc"
  end

end
