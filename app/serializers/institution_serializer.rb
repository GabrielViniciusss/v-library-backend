class InstitutionSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :city, :created_at
end