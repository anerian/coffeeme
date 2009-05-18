# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090518043126) do

  create_table "drinks", :force => true do |t|
    t.string  "name"
    t.integer "serving_size",        :default => 0
    t.integer "calories",            :default => 0
    t.integer "fat_calories",        :default => 0
    t.integer "total_fat",           :default => 0
    t.integer "saturated_fat",       :default => 0
    t.integer "trans_fat",           :default => 0
    t.integer "cholesterol",         :default => 0
    t.integer "sodium",              :default => 0
    t.integer "total_carbohydrates", :default => 0
    t.integer "fiber",               :default => 0
    t.integer "sugars",              :default => 0
    t.integer "protein",             :default => 0
    t.integer "size"
    t.integer "milk"
    t.integer "store_type",                         :null => false
    t.integer "caffeine"
  end

  create_table "stores", :force => true do |t|
    t.string  "street"
    t.string  "city"
    t.string  "state"
    t.string  "zip",        :limit => 5
    t.string  "phone"
    t.decimal "latitude",                :precision => 15, :scale => 6
    t.decimal "longitude",               :precision => 15, :scale => 6
    t.integer "store_type",                                             :default => 0
  end

  create_table "trivias", :force => true do |t|
    t.text "fact"
  end

end
