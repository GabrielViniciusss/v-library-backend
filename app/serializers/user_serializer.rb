class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :created_at   # Apenas estes campos serão incluídos na resposta JSON
end