class MaterialSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :description, :status, :type, :created_at # genericos
  belongs_to :user
  belongs_to :author, polymorphic: true
end