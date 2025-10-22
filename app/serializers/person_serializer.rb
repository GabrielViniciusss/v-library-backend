class PersonSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :date_of_birth, :created_at
end