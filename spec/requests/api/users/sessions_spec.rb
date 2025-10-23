# spec/requests/api/users/sessions_spec.rb

require 'swagger_helper'

RSpec.describe 'api/users/sessions', type: :request do

  path '/api/login' do
    post('create session') do
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
              password: { type: :string, example: 'password123' }
            },
            required: %w[email password]
          }
        },
        required: %w[user]
      }

      response(200, 'successful') do
        # Modificado: Usa let! e create(:user)
        let!(:existing_user) { create(:user, email: 'test@example.com', password: 'password123') }
        let(:user) { { user: { email: existing_user.email, password: 'password123' } } }

        run_test!
      end

      response(401, 'unauthorized') do
        let(:user) { { user: { email: 'wrong@example.com', password: 'wrong' } } }
        run_test!
      end
    end
  end
end