# spec/support/devise.rb
require 'devise'

RSpec.configure do |config|
  # Inclui os helpers de teste do Devise para controllers e requests
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request # <-- ESSENCIAL para Rswag/Request specs
end