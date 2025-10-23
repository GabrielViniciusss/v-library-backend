# spec/requests/api/institutions_spec.rb

require 'swagger_helper'

RSpec.describe 'api/institutions', type: :request do

  path '/api/institutions' do
    get('list institutions') do
      tags 'Authors (Institutions)'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Número da página', required: false

      response(200, 'successful') do
        let!(:institution) { create(:institution) }
        run_test!
      end
    end

    post('create institution') do
      tags 'Authors (Institutions)'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :institution, in: :body, schema: {
        type: :object,
        properties: {
          institution: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Universidade de Oxford' },
              city: { type: :string, example: 'Oxford' }
            },
            required: %w[name city]
          }
        },
        required: %w[institution]
      }

      response(201, 'created') do
        let!(:user) { create(:user) }
        # Modificado: Adiciona scp: 'user'
        let(:token) do
          payload = { sub: user.id, scp: 'user', exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }

        let(:institution) { { institution: { name: 'Universidade de Oxford', city: 'Oxford' } } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid' }
        let(:institution) { { institution: { name: 'Universidade de Oxford' } } }
        run_test!
      end
    end
  end

  path '/api/institutions/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'ID da instituição'
    let!(:institution_record) { create(:institution) }

    get('show institution') do
      tags 'Authors (Institutions)'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { institution_record.id }
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'invalid-id' }
        run_test!
      end
    end

    put('update institution') do
      tags 'Authors (Institutions)'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :institution, in: :body, schema: {
        type: :object,
        properties: { institution: { type: :object, properties: { name: { type: :string } } } }
      }

      response(200, 'successful') do
        let!(:user) { create(:user) }
        # Modificado: Adiciona scp: 'user'
        let(:token) do
          payload = { sub: user.id, scp: 'user', exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }

        let(:id) { institution_record.id }
        let(:institution) { { institution: { name: 'MIT Media Lab' } } }
        run_test!
      end
    end

    delete('delete institution') do
      tags 'Authors (Institutions)'
      security [ Bearer: [] ]

      response(204, 'no content') do
        let!(:user) { create(:user) }
        # Modificado: Adiciona scp: 'user'
        let(:token) do
          payload = { sub: user.id, scp: 'user', exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }

        let(:id) { institution_record.id }
        run_test!
      end
    end
  end
end