# spec/requests/api/users/registrations_spec.rb

require 'swagger_helper'

RSpec.describe 'api/users/registrations', type: :request do

  path '/api/signup' do
    post('create registration') do
      tags 'Autenticação'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string, example: 'user@example.com' },
              password: { type: :string, example: 'password123' },
              password_confirmation: { type: :string, example: 'password123' }
            },
            required: %w[email password password_confirmation]
          }
        },
        required: %w[user]
      }

      response(200, 'successful') do
        let(:user) { { user: { email: 'test@example.com', password: 'password123', password_confirmation: 'password123' } } }
        run_test!
      end

      response(422, 'unprocessable entity') do
        # Cria um usuário para testar a falha de e-mail único
        let!(:existing_user) { create(:user, email: 'test@example.com') }
        let(:user) { { user: { email: 'test@example.com', password: '123' } } }
        run_test!
      end
    end
  end
end