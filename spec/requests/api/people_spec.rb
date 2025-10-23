# spec/requests/api/people_spec.rb

require 'swagger_helper'

RSpec.describe 'api/people', type: :request do

  path '/api/people' do
    get('list people') do
      tags 'Authors (People)'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Número da página', required: false

      response(200, 'successful') do
        let!(:person) { create(:person) }
        run_test!
      end
    end

    post('create person') do
      tags 'Authors (People)'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :person, in: :body, schema: {
        type: :object,
        properties: {
          person: {
            type: :object,
            properties: {
              name: { type: :string, example: 'J.R.R. Tolkien' },
              date_of_birth: { type: :string, format: :date, example: '1892-01-03' }
            },
            required: %w[name date_of_birth]
          }
        },
        required: %w[person]
      }

      response(201, 'created') do
        let!(:user) { create(:user) }
        # Modificado: Adiciona JTI
        let(:token) do
          payload = { sub: user.id, exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        
        let(:person) { { person: { name: 'J.R.R. Tolkien', date_of_birth: '1892-01-03' } } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid' }
        let(:person) { { person: { name: 'J.R.R. Tolkien', date_of_birth: '1892-01-03' } } }
        run_test!
      end
      
      response(422, 'unprocessable entity') do
        let!(:user) { create(:user) }
        # Modificado: Adiciona JTI
        let(:token) do
          payload = { sub: user.id, exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        
        let(:person) { { person: { name: 'J' } } } # Nome muito curto
        run_test!
      end
    end
  end

  path '/api/people/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'ID da pessoa'
    let!(:person_record) { create(:person) }

    get('show person') do
      tags 'Authors (People)'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { person_record.id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid-id' }
        run_test!
      end
    end

    put('update person') do
      tags 'Authors (People)'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :person, in: :body, schema: {
        type: :object,
        properties: { person: { type: :object, properties: { name: { type: :string } } } }
      }

      response(200, 'successful') do
        let!(:user) { create(:user) }
        # Modificado: Adiciona JTI
        let(:token) do
          payload = { sub: user.id, exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        
        let(:id) { person_record.id }
        let(:person) { { person: { name: 'George R. R. Martin' } } }
        run_test!
      end
    end

    delete('delete person') do
      tags 'Authors (People)'
      security [ Bearer: [] ]

      response(204, 'no content') do
        let!(:user) { create(:user) }
        # Modificado: Adiciona JTI
        let(:token) do
          payload = { sub: user.id, exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        
        let(:id) { person_record.id }
        run_test!
      end
    end
  end
end