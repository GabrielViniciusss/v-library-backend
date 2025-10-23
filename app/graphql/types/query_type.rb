# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :materials, [Types::MaterialType], null: false, description: "List materials with optional pagination" do
      argument :page, Integer, required: false, default_value: 1
      argument :per_page, Integer, required: false, default_value: 20
    end

    def materials(page:, per_page:)
      ::Material.order(created_at: :desc).page(page).per(per_page)
    end

    field :material, Types::MaterialType, null: true, description: "Find a material by ID" do
      argument :id, ID, required: true
    end

    def material(id:)
      ::Material.find_by(id: id)
    end

    field :people, [Types::PersonType], null: false, description: "List all people"

    def people
      ::Person.order(:name)
    end

    field :institutions, [Types::InstitutionType], null: false, description: "List all institutions"

    def institutions
      ::Institution.order(:name)
    end
  end
end
