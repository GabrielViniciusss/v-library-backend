# spec/requests/api/articles_spec.rb

require 'swagger_helper'

RSpec.describe 'api/articles', type: :request do

  path '/api/articles' do
    get('list articles') do
      tags 'Materials (Articles)'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Número da página', required: false

      response(200, 'successful') do
        let!(:article) { create(:article) }
        run_test!
      end
    end

    post('create article') do
      tags 'Materials (Articles)'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :article, in: :body, schema: {
        type: :object,
        properties: {
          article: {
            type: :object,
            properties: {
              title: { type: :string, example: 'Estudo sobre IA' },
              description: { type: :string, example: 'Um artigo...' },
              status: { type: :string, example: 'published' },
              author_id: { type: :integer, example: 1 },
              author_type: { type: :string, example: 'Institution' },
              doi: { type: :string, example: '10.1000/xyz123' }
            },
            required: %w[title status author_id author_type doi]
          }
        },
        required: %w[article]
      }

      response(201, 'created') do
        let!(:user) { create(:user) }
        # Modificado: Adiciona JTI
        let(:token) do
          payload = { sub: user.id, exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        let!(:author) { create(:institution) }
        
        let(:article) { { article: { title: 'Estudo sobre IA', status: 'published', author_id: author.id, author_type: 'Institution', doi: '10.1000/xyz123' } } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid' }
        let!(:author) { create(:institution) }
        let(:article) { { article: { title: 'Estudo sobre IA', status: 'published', author_id: author.id, author_type: 'Institution', doi: '10.1000/xyz123' } } }
        run_test!
      end
    end
  end

  path '/api/articles/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'ID do artigo'
    
    let!(:creator_user) { create(:user, email: 'creator@example.com') }
    let!(:other_user) { create(:user, email: 'other@example.com') }
    let!(:author) { create(:institution) }
    let!(:article_record) { create(:article, user: creator_user, author: author) }
    let(:id) { article_record.id }

    get('show article') do
      tags 'Materials (Articles)'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
      response(404, 'not found') do
        let(:id) { 'invalid-id' }
        run_test!
      end
    end

    put('update article') do
      tags 'Materials (Articles)'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :article, in: :body, schema: {
        type: :object, properties: { article: { type: :object, properties: { title: { type: :string } } } }
      }

      response(200, 'successful') do
        # Modificado: Adiciona JTI
        let(:token) do
          payload = { sub: creator_user.id, exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        let(:article) { { article: { title: 'New Title' } } }
        run_test!
      end

      response(403, 'forbidden') do
        # Modificado: Adiciona JTI
        let(:token) do
          payload = { sub: other_user.id, exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        let(:article) { { article: { title: 'Malicious Title' } } }
        run_test!
      end
    end

    delete('delete article') do
      tags 'Materials (Articles)'
      security [ Bearer: [] ]

      response(204, 'no content') do
        # Modificado: Adiciona JTI
        let(:token) do
          payload = { sub: creator_user.id, exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end

      response(403, 'forbidden') do
        # Modificado: Adiciona JTI
        let(:token) do
          payload = { sub: other_user.id, exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end
    end
  end
end