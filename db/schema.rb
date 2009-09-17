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

ActiveRecord::Schema.define(:version => 20090917091727) do

  create_table "etiquetages", :force => true do |t|
    t.integer "tache_id"
    t.integer "tag_id"
  end

  create_table "projets", :force => true do |t|
    t.date "date_stabilisation_backlog"
  end

  create_table "taches", :force => true do |t|
    t.text    "description"
    t.text    "commentaire"
    t.integer "poids",       :default => 1
    t.string  "statut"
    t.date    "date_entree"
    t.date    "date_sortie"
    t.integer "projet_id"
  end

  create_table "tags", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
