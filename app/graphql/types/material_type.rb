# frozen_string_literal: true

module Types
  class MaterialType < Types::BaseObject
    description "A library material (Book, Article, or Video)"

    field :id, ID, null: false
    field :title, String, null: false
    field :description, String, null: true
    field :status, String, null: false
    field :type, String, null: false, description: "STI type: Book, Article, or Video"

    # Optional, only present for some subclasses
    field :isbn, String, null: true
    field :pages, Integer, null: true
    field :doi, String, null: true
    field :duration_in_minutes, Integer, null: true

    field :author_type, String, null: false
    field :author_id, Integer, null: false
    field :user_id, Integer, null: false

    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
