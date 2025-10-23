# frozen_string_literal: true

module Types
  class PersonType < Types::BaseObject
    description "An individual author"

    field :id, ID, null: false
    field :name, String, null: false
    field :date_of_birth, GraphQL::Types::ISO8601Date, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
