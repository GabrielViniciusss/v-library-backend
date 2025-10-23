# config/initializers/rswag_ui.rb
Rswag::Ui.configure do |c|
  # ...
  # A UI vai pedir este arquivo para o Rswag::Api
  c.swagger_endpoint '/api-docs/v1/swagger.yaml', 'API V1 Docs'
  # ...
end