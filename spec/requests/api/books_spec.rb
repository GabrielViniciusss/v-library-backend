# spec/requests/api/books_spec.rb

require 'swagger_helper'

RSpec.describe 'api/books', type: :request do

  path '/api/books' do
    get('list books') do
      tags 'Materials (Books)'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Número da página', required: false

      response(200, 'successful') do
        let!(:book) { create(:book) }
        run_test!
      end
    end

    post('create book') do
      tags 'Materials (Books)'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :book, in: :body, schema: {
        type: :object,
        properties: {
          book: {
            type: :object,
            properties: {
              title: { type: :string, example: 'O Hobbit' },
              description: { type: :string, example: 'Uma aventura...' },
              status: { type: :string, example: 'published' },
              author_id: { type: :integer, example: 1 },
              author_type: { type: :string, example: 'Person' },
              isbn: { type: :string, example: '9780547928227' },
              pages: { type: :integer, example: 310 }
            },
            required: %w[title status author_id author_type isbn pages]
          }
        },
        required: %w[book]
      }

      response(201, 'created') do
        let!(:user) { create(:user) }
        let(:token) do
          payload = { sub: user.id, scp: 'user', exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        let!(:author) { create(:person) }
        
        let(:book) { { book: { title: 'O Hobbit', status: 'published', author_id: author.id, author_type: 'Person', isbn: '9780547928227', pages: 310 } } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid' }
        let!(:author) { create(:person) }
        let(:book) { { book: { title: 'O Hobbit', status: 'published', author_id: author.id, author_type: 'Person', isbn: '9780547928227', pages: 310 } } }
        run_test!
      end
    end
  end

  path '/api/books/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'ID do livro'
    
    let!(:creator_user) { create(:user, email: 'creator@example.com') }
    let!(:other_user) { create(:user, email: 'other@example.com') }
    let!(:author) { create(:person) }
    let!(:book_record) { create(:book, user: creator_user, author: author) }
    let(:id) { book_record.id }

    get('show book') do
      tags 'Materials (Books)'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
      response(404, 'not found') do
        let(:id) { 'invalid-id' }
        run_test!
      end
    end

    put('update book') do
      tags 'Materials (Books)'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :book, in: :body, schema: {
        type: :object, properties: { book: { type: :object, properties: { title: { type: :string } } } }
      }

      response(200, 'successful') do
        let(:token) do
          payload = { sub: creator_user.id, scp: 'user', exp: 1.day.from_now.to_i, jti: SecureRandom.uuid } # Usa creator_user
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        # ---------------------
        let(:Authorization) { "Bearer #{token}" }
        let(:book) { { book: { title: 'New Title' } } }
        run_test!
      end

      response(403, 'forbidden') do
        let(:token) do
          payload = { sub: other_user.id, scp: 'user', exp: 1.day.from_now.to_i, jti: SecureRandom.uuid } # Usa other_user
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        let(:book) { { book: { title: 'Malicious Title' } } }
        run_test!
      end
    end

    delete('delete book') do
      tags 'Materials (Books)'
      security [ Bearer: [] ]

      response(204, 'no content') do
        let(:token) do
          payload = { sub: creator_user.id, scp: 'user', exp: 1.day.from_now.to_i, jti: SecureRandom.uuid } # Usa creator_user
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end

      response(403, 'forbidden') do
        let(:token) do
          payload = { sub: other_user.id, scp: 'user', exp: 1.day.from_now.to_i, jti: SecureRandom.uuid } # Usa other_user
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end
    end
  end
end