# frozen_string_literal: true

module Types
  class InstitutionType < Types::BaseObject
    description "An institutional author"

    field :id, ID, null: false
    field :name, String, null: false
    field :city, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
