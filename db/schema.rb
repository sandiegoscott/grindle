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

ActiveRecord::Schema.define(:version => 20130712474747) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "abbrev"
    t.string   "ctype"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "inspection_form_id"
    t.integer  "creator_id"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "defects", :force => true do |t|
    t.integer  "inspection_form_id"
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.string   "status",             :limit => 12
    t.datetime "date_called"
    t.boolean  "is_called"
    t.datetime "date_completed"
    t.boolean  "is_completed"
  end

  create_table "inspection_forms", :force => true do |t|
    t.integer  "rbuilder_id"
    t.date     "idate"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "jobnumber"
    t.string   "status"
    t.string   "itype"
    t.boolean  "passed"
    t.boolean  "rinpreq"
    t.boolean  "corpro"
    t.boolean  "houseclean"
    t.boolean  "elcmeter"
    t.boolean  "gasmeter"
    t.boolean  "appliances"
    t.boolean  "rpassed"
    t.boolean  "rrinpreq"
    t.boolean  "rcorpro"
    t.boolean  "rhouseclean"
    t.boolean  "relecmeter"
    t.boolean  "rgasmeter"
    t.boolean  "rappliances"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subdivision_id"
    t.integer  "inspector_id"
    t.integer  "superintendent_id"
    t.integer  "areamanger_id"
    t.date     "ridate"
    t.integer  "rinspector_id"
    t.boolean  "otsr"
    t.boolean  "oti"
    t.boolean  "otb"
    t.boolean  "fgpass"
    t.boolean  "fgcap"
    t.boolean  "fgcfr"
    t.string   "slug"
    t.boolean  "dr_horton"
    t.string   "name",              :limit => 60
    t.string   "phone",             :limit => 20
    t.string   "his_phone",         :limit => 20
    t.string   "her_phone",         :limit => 20
    t.boolean  "kitchen"
    t.boolean  "bathrooms"
    t.boolean  "painting"
    t.boolean  "doors"
    t.boolean  "house_keys"
    t.boolean  "windows"
    t.boolean  "floors"
    t.boolean  "fireplace"
    t.boolean  "brick"
    t.boolean  "roof"
    t.boolean  "exterior"
    t.boolean  "operation"
    t.boolean  "detectors"
    t.boolean  "electrical1"
    t.boolean  "electrical2"
    t.boolean  "concrete"
    t.boolean  "lot"
    t.boolean  "locations"
    t.boolean  "warranty"
    t.boolean  "utility"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subdivisions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                             :default => "User"
    t.boolean  "inactive"
    t.string   "persistence_token"
    t.integer  "login_count",                      :default => 0,      :null => false
    t.integer  "failed_login_count",               :default => 0,      :null => false
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.integer  "rbuilder_id"
    t.string   "default_city",       :limit => 30
    t.string   "group_name",         :limit => 50
    t.string   "office",             :limit => 20
    t.string   "mobile",             :limit => 20
    t.string   "fax",                :limit => 20
  end

end
