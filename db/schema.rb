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

ActiveRecord::Schema.define(version: 2020_04_05_053933) do

  create_table "annotations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "a_id"
    t.string "a_type"
    t.string "concept"
    t.bigint "user_id"
    t.text "content"
    t.string "note"
    t.integer "offset", default: 0
    t.string "passage"
    t.bigint "assign_id"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "document_id"
    t.string "annotator", limit: 3000
    t.text "infons"
    t.integer "a_id_no"
    t.integer "version", default: 0
    t.integer "review_result", default: 0
    t.index ["assign_id"], name: "index_annotations_on_assign_id"
    t.index ["document_id", "user_id"], name: "index_annotations_on_document_id_and_user_id"
    t.index ["user_id"], name: "index_annotations_on_user_id"
  end

  create_table "api_keys", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "key"
    t.bigint "user_id"
    t.datetime "last_access_at"
    t.string "last_access_ip"
    t.integer "access_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "assigns", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "document_id"
    t.bigint "user_id"
    t.boolean "done", default: false
    t.boolean "curatable", default: false
    t.datetime "begin_at"
    t.datetime "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_user_id"
    t.boolean "detached", default: false
    t.integer "annotations_count", default: 0
    t.index ["document_id"], name: "index_assigns_on_document_id"
    t.index ["project_id"], name: "index_assigns_on_project_id"
    t.index ["project_user_id"], name: "index_assigns_on_project_user_id"
    t.index ["user_id"], name: "index_assigns_on_user_id"
  end

  create_table "audits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "project_id"
    t.bigint "document_id"
    t.bigint "annotation_id"
    t.bigint "relation_id"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "request"
    t.text "result"
    t.index ["annotation_id"], name: "index_audits_on_annotation_id"
    t.index ["document_id"], name: "index_audits_on_document_id"
    t.index ["project_id"], name: "index_audits_on_project_id"
    t.index ["relation_id"], name: "index_audits_on_relation_id"
    t.index ["user_id"], name: "index_audits_on_user_id"
  end

  create_table "documents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "project_id"
    t.string "did"
    t.datetime "user_updated_at"
    t.datetime "tool_updated_at"
    t.text "xml"
    t.text "title"
    t.string "key"
    t.integer "did_no"
    t.integer "batch_id"
    t.integer "batch_no"
    t.integer "order_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "assigns_count", default: 0
    t.integer "version", default: 0
    t.datetime "xml_at"
    t.integer "done_count", default: 0
    t.text "content2"
    t.integer "curatable_count", default: 0
    t.text "infons"
    t.index ["project_id"], name: "index_documents_on_project_id"
  end

  create_table "entity_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "project_id"
    t.string "name", default: "", null: false
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prefix"
    t.index ["project_id"], name: "index_entity_types_on_project_id"
  end

  create_table "lexicon_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.bigint "project_id"
    t.string "key"
    t.integer "lexicons_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_lexicon_groups_on_project_id"
  end

  create_table "lexicons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "ltype"
    t.string "lexicon_id"
    t.text "name"
    t.bigint "lexicon_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lexicon_group_id"], name: "index_lexicons_on_lexicon_group_id"
  end

  create_table "models", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "url"
    t.bigint "project_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_models_on_project_id"
  end

  create_table "nodes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "relation_id"
    t.integer "order_no"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ref_id"
    t.bigint "document_id"
    t.integer "version"
    t.index ["document_id"], name: "index_nodes_on_document_id"
    t.index ["relation_id"], name: "index_nodes_on_relation_id"
  end

  create_table "project_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "user_id"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_users_on_project_id"
    t.index ["user_id"], name: "index_project_users_on_user_id"
  end

  create_table "projects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "desc"
    t.integer "round", default: 0
    t.integer "documents_count", default: 0
    t.string "cdate"
    t.string "key"
    t.string "source"
    t.string "xml_url"
    t.integer "annotations_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "round_state", default: 0
    t.integer "entity_types_count", default: 0
    t.integer "project_users_count", default: 0
    t.integer "assigns_count", default: 0
    t.integer "lexicon_groups_count", default: 0
    t.integer "models_count", default: 0
    t.integer "tasks_count", default: 0
    t.boolean "locked", default: false
    t.boolean "done", default: false
    t.integer "relation_types_count", default: 0
    t.boolean "finalized", default: false
    t.boolean "enable_audit", default: false
    t.boolean "collaborate_round", default: false
    t.text "collaborates"
  end

  create_table "relation_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.integer "num_nodes", default: 2
    t.string "entity_type"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_relation_types_on_project_id"
  end

  create_table "relations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "r_id"
    t.string "r_type"
    t.bigint "user_id"
    t.string "note", default: ""
    t.text "infons"
    t.string "annotator", limit: 3000
    t.bigint "document_id"
    t.bigint "assign_id"
    t.string "passage"
    t.integer "r_id_no"
    t.integer "version", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sig1", limit: 5000
    t.string "sig2", limit: 5000
    t.integer "review_result", default: 0
    t.index ["assign_id"], name: "index_relations_on_assign_id"
    t.index ["document_id"], name: "index_relations_on_document_id"
    t.index ["user_id"], name: "index_relations_on_user_id"
  end

  create_table "tasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "project_id"
    t.string "tagger"
    t.integer "task_type"
    t.string "pre_trained_model"
    t.string "status"
    t.string "tool_begin_at"
    t.string "tool_end_at"
    t.string "canceled_at"
    t.bigint "model_id"
    t.bigint "lexicon_group_id"
    t.boolean "has_model", default: false
    t.boolean "has_lexicon_group", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lexicon_group_id"], name: "index_tasks_on_lexicon_group_id"
    t.index ["model_id"], name: "index_tasks_on_model_id"
    t.index ["project_id"], name: "index_tasks_on_project_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "upload_batches", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "session_str"
    t.string "ip"
    t.boolean "super_admin", default: false
    t.string "provider"
    t.string "uid"
    t.string "token"
    t.integer "expires_at"
    t.boolean "expires"
    t.string "refresh_token"
    t.string "image"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["ip"], name: "index_users_on_ip"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["session_str"], name: "index_users_on_session_str"
  end

  add_foreign_key "annotations", "assigns"
  add_foreign_key "annotations", "users"
  add_foreign_key "api_keys", "users"
  add_foreign_key "assigns", "documents"
  add_foreign_key "assigns", "projects"
  add_foreign_key "assigns", "users"
  add_foreign_key "audits", "annotations"
  add_foreign_key "audits", "documents"
  add_foreign_key "audits", "projects"
  add_foreign_key "audits", "relations"
  add_foreign_key "audits", "users"
  add_foreign_key "documents", "projects"
  add_foreign_key "entity_types", "projects"
  add_foreign_key "lexicon_groups", "projects"
  add_foreign_key "lexicons", "lexicon_groups"
  add_foreign_key "models", "projects"
  add_foreign_key "nodes", "documents"
  add_foreign_key "nodes", "relations"
  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "users"
  add_foreign_key "relation_types", "projects"
  add_foreign_key "relations", "assigns"
  add_foreign_key "relations", "documents"
  add_foreign_key "relations", "users"
  add_foreign_key "tasks", "lexicon_groups"
  add_foreign_key "tasks", "models"
  add_foreign_key "tasks", "projects"
  add_foreign_key "tasks", "users"
end
