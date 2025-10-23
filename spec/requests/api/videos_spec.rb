# spec/requests/api/videos_spec.rb

require 'swagger_helper'

RSpec.describe 'api/videos', type: :request do

  path '/api/videos' do
    get('list videos') do
      tags 'Materials (Videos)'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, description: 'Número da página', required: false

      response(200, 'successful') do
        let!(:video) { create(:video) }
        run_test!
      end
    end

    post('create video') do
      tags 'Materials (Videos)'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :video, in: :body, schema: {
        type: :object,
        properties: {
          video: {
            type: :object,
            properties: {
              title: { type: :string, example: 'Palestra sobre Rails' },
              description: { type: :string, example: 'Uma palestra...' },
              status: { type: :string, example: 'published' },
              author_id: { type: :integer, example: 1 },
              author_type: { type: :string, example: 'Person' },
              duration_in_minutes: { type: :integer, example: 45 }
            },
            required: %w[title status author_id author_type duration_in_minutes]
          }
        },
        required: %w[video]
      }

      response(201, 'created') do
        let!(:user) { create(:user) }
        # Modificado: Adiciona scp: 'user'
        let(:token) do
          payload = { sub: user.id, scp: 'user', exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        let!(:author) { create(:person) }

        let(:video) { { video: { title: 'Palestra sobre Rails', status: 'published', author_id: author.id, author_type: 'Person', duration_in_minutes: 45 } } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:Authorization) { 'Bearer invalid' }
        let!(:author) { create(:person) }
        let(:video) { { video: { title: 'Palestra sobre Rails', status: 'published', author_id: author.id, author_type: 'Person', duration_in_minutes: 45 } } }
        run_test!
      end
    end
  end

  path '/api/videos/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'ID do vídeo'

    let!(:creator_user) { create(:user, email: 'creator@example.com') }
    let!(:other_user) { create(:user, email: 'other@example.com') }
    let!(:author) { create(:person) }
    let!(:video_record) { create(:video, user: creator_user, author: author) }
    let(:id) { video_record.id }

    get('show video') do
      tags 'Materials (Videos)'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
      response(404, 'not found') do
        let(:id) { 'invalid-id' }
        run_test!
      end
    end

    put('update video') do
      tags 'Materials (Videos)'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :video, in: :body, schema: {
        type: :object, properties: { video: { type: :object, properties: { title: { type: :string } } } }
      }

      response(200, 'successful') do
        # Modificado: Adiciona scp: 'user' (para creator_user)
        let(:token) do
          payload = { sub: creator_user.id, scp: 'user', exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        let(:video) { { video: { title: 'New Title' } } }
        run_test!
      end

      response(403, 'forbidden') do
        # Modificado: Adiciona scp: 'user' (para other_user)
        let(:token) do
          payload = { sub: other_user.id, scp: 'user', exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        let(:video) { { video: { title: 'Malicious Title' } } }
        run_test!
      end
    end

    delete('delete video') do
      tags 'Materials (Videos)'
      security [ Bearer: [] ]

      response(204, 'no content') do
        # Modificado: Adiciona scp: 'user' (para creator_user)
        let(:token) do
          payload = { sub: creator_user.id, scp: 'user', exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end

      response(403, 'forbidden') do
        # Modificado: Adiciona scp: 'user' (para other_user)
        let(:token) do
          payload = { sub: other_user.id, scp: 'user', exp: 1.day.from_now.to_i, jti: SecureRandom.uuid }
          JWT.encode(payload, Rails.application.credentials.devise_jwt_secret)
        end
        let(:Authorization) { "Bearer #{token}" }
        run_test!
      end
    end
  end
end