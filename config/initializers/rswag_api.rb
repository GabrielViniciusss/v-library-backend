# config/initializers/rswag_api.rb
Rswag::Api.configure do |c|
  # Especifica a pasta raiz onde os arquivos Swagger são gerados.
  # DEVE bater com o 'openapi_root' do swagger_helper.rb
  c.openapi_root = Rails.root.join('swagger').to_s
end