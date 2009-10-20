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

ActiveRecord::Schema.define(:version => 20091020002958) do

  create_table "app_settings", :primary_key => "ID", :force => true do |t|
    t.string  "Label", :default => "", :null => false
    t.string  "Value", :default => "", :null => false
    t.integer "Type",  :default => 0,  :null => false
  end

  create_table "article", :primary_key => "ID", :force => true do |t|
    t.string   "TITLE"
    t.string   "ABSTRACT"
    t.text     "KEYWORDS"
    t.integer  "AUTHOR"
    t.text     "DOM"
    t.datetime "CREATION"
    t.datetime "LASTMODIFIED"
    t.string   "ARTICLETYPE",    :limit => 10
    t.integer  "PUBLISHED",      :limit => 2
    t.text     "AssocWebPages"
    t.text     "AssocDocuments"
  end

  create_table "article_to_section", :primary_key => "ID", :force => true do |t|
    t.integer "ArticleID"
    t.integer "SectionID"
  end

  create_table "category", :primary_key => "ID", :force => true do |t|
    t.string "name",        :limit => 100, :default => "", :null => false
    t.string "Description"
  end

  create_table "faq", :primary_key => "ID", :force => true do |t|
    t.string   "Title"
    t.text     "Abstract"
    t.text     "Contents"
    t.integer  "Status",       :limit => 1
    t.datetime "CreationDate"
    t.integer  "Category"
  end

  add_index "faq", ["ID"], :name => "ID", :unique => true

  create_table "files", :force => true do |t|
    t.string  "file_name", :limit => 30
    t.string  "file_type", :limit => 5
    t.integer "faq_id",                  :default => 0,  :null => false
    t.string  "file_path",               :default => "", :null => false
    t.string  "file_desc",               :default => "", :null => false
  end

  create_table "orders", :force => true do |t|
    t.integer  "parent_id"
    t.string   "type",               :limit => 11
    t.integer  "status"
    t.integer  "org_id"
    t.integer  "creator_id"
    t.integer  "auth_by_id"
    t.integer  "address_id"
    t.datetime "created_date"
    t.datetime "updated_date"
    t.date     "required_date"
    t.string   "grade_abbrev",       :limit => 20
    t.integer  "calliper"
    t.integer  "sheets"
    t.integer  "width"
    t.integer  "length"
    t.decimal  "price",                            :precision => 10, :scale => 4
    t.string   "notes"
    t.string   "your_ref"
    t.decimal  "price_sys_adj",                    :precision => 10, :scale => 4
    t.integer  "price_sys_reason"
    t.decimal  "price_admin_adj",                  :precision => 10, :scale => 4
    t.integer  "price_admin_reason"
    t.integer  "gsm"
    t.integer  "reel"
    t.integer  "kilos"
    t.decimal  "rate",                             :precision => 10, :scale => 4
    t.integer  "setup_surcharge"
    t.string   "stock_status"
  end

  create_table "org_addresses", :force => true do |t|
    t.integer "org_id",                    :default => 0, :null => false
    t.string  "st_address1", :limit => 80
    t.string  "st_address2", :limit => 80
    t.string  "st_city",     :limit => 30
    t.string  "st_state",    :limit => 30
    t.string  "st_postcode", :limit => 20
    t.string  "st_country",  :limit => 40
    t.string  "phone"
    t.string  "fax"
    t.string  "email"
    t.string  "web"
    t.text    "description"
    t.integer "status"
    t.integer "sort"
  end

  create_table "pricing_data", :force => true do |t|
    t.string   "name",            :limit => 100
    t.string   "grade",           :limit => 100
    t.string   "grade_abbrev",    :limit => 20
    t.string   "subgrade_abbrev", :limit => 20
    t.integer  "calliper"
    t.integer  "gsm"
    t.integer  "break"
    t.decimal  "price",                          :precision => 10, :scale => 4
    t.integer  "price_type"
    t.datetime "date_uploaded"
    t.integer  "status"
  end

  create_table "pricing_group_names", :force => true do |t|
    t.string   "name",          :limit => 100
    t.integer  "status",                       :default => 1
    t.datetime "date_uploaded"
  end

  create_table "pricing_groups", :force => true do |t|
    t.integer  "group_name_id"
    t.integer  "price_id"
    t.integer  "status",        :default => 1
    t.datetime "date_uploaded"
    t.integer  "sort"
  end

  create_table "pricing_lines", :force => true do |t|
    t.string   "name",          :limit => 100
    t.string   "grade_abbrev",  :limit => 20
    t.integer  "status",                       :default => 1
    t.datetime "date_uploaded"
  end

  create_table "product_grades", :force => true do |t|
    t.string   "name",          :limit => 100
    t.string   "grade_abbrev",  :limit => 20
    t.integer  "status",                       :default => 1
    t.datetime "date_uploaded"
  end

  create_table "product_reels", :force => true do |t|
    t.string   "grade",           :limit => 100
    t.string   "grade_abbrev",    :limit => 20
    t.string   "subgrade_abbrev", :limit => 20
    t.integer  "calliper"
    t.integer  "gsm"
    t.integer  "reel_size"
    t.datetime "date_uploaded"
    t.string   "sap_code"
    t.string   "sap_alt_code_1"
    t.string   "sap_alt_code_2"
  end

  create_table "sections", :force => true do |t|
    t.string  "Name",        :default => "", :null => false
    t.integer "Author",      :default => 0,  :null => false
    t.text    "Header"
    t.text    "Description"
    t.text    "Links"
    t.text    "Footer"
  end

  create_table "sections_to_groups", :force => true do |t|
    t.integer "Section_ID"
    t.integer "Group_ID"
  end

  create_table "shell_groups", :primary_key => "Group_ID", :force => true do |t|
    t.string  "Name",        :limit => 40
    t.string  "Description", :limit => 80
    t.integer "Owner"
    t.integer "Inherit",                   :default => 0, :null => false
  end

  create_table "shell_option_sets", :force => true do |t|
    t.string  "name"
    t.string  "descr"
    t.integer "data_protected"
    t.integer "default_first_option"
    t.integer "parent"
    t.integer "has_kids"
    t.integer "sort"
  end

  create_table "shell_options", :primary_key => "ID", :force => true do |t|
    t.string  "Description"
    t.string  "Module"
    t.string  "Function"
    t.string  "Target"
    t.integer "Type"
    t.string  "Other_args"
    t.integer "Option_Set_ID"
    t.integer "sort"
  end

  create_table "shell_organisations", :force => true do |t|
    t.string  "name",             :limit => 40
    t.string  "st_address1",      :limit => 80
    t.string  "st_address2",      :limit => 80
    t.string  "st_city",          :limit => 30
    t.string  "st_state",         :limit => 30
    t.string  "st_postcode",      :limit => 20
    t.string  "st_country",       :limit => 40
    t.string  "po_address1",      :limit => 80
    t.string  "po_address2",      :limit => 80
    t.string  "po_city",          :limit => 30
    t.string  "po_state",         :limit => 30
    t.string  "po_postcode",      :limit => 20
    t.string  "po_country",       :limit => 40
    t.string  "phone"
    t.string  "fax"
    t.string  "email"
    t.string  "web"
    t.text    "description"
    t.integer "logoimagetype",    :limit => 3
    t.integer "live",             :limit => 3
    t.integer "RegionID"
    t.integer "status"
    t.text    "Cello_cust_code"
    t.integer "pricing_group_id"
    t.integer "cello_rep_id"
  end

  create_table "shell_permissions", :primary_key => "ID", :force => true do |t|
    t.integer "User_Group_ID"
    t.integer "Option_set_ID"
    t.string  "Label"
    t.integer "is_menu"
    t.string  "Other_args"
    t.string  "Target"
    t.string  "Tool_tip"
    t.integer "First_option"
  end

  create_table "shell_useraccess", :primary_key => "Access_ID", :force => true do |t|
    t.integer "User_ID"
    t.integer "Group_ID"
  end

  create_table "shell_users", :primary_key => "User_ID", :force => true do |t|
    t.string   "Username",     :limit => 40
    t.string   "Password",     :limit => 32
    t.string   "passwordhint"
    t.datetime "LastLogin"
    t.integer  "NumLogins"
    t.string   "FirstName",    :limit => 40
    t.string   "LastName",     :limit => 40
    t.integer  "Organisation"
    t.string   "Addr1",        :limit => 50
    t.string   "Addr2",        :limit => 50
    t.string   "Addr3",        :limit => 50
    t.string   "City",         :limit => 50
    t.string   "State",        :limit => 50
    t.string   "Postcode",     :limit => 10
    t.string   "Country",      :limit => 50
    t.string   "Phone",        :limit => 20
    t.string   "Fax",          :limit => 20
    t.string   "Mobile",       :limit => 20
    t.string   "Email",        :limit => 150
    t.integer  "EmailType",    :limit => 3
    t.string   "PersonalURL"
    t.string   "Job_Title"
    t.datetime "DateofMember"
    t.integer  "Status",       :limit => 1,   :default => 0
    t.integer  "cello_rep"
  end

end
