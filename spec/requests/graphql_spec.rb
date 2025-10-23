require 'rails_helper'

RSpec.describe 'GraphQL API', type: :request do
  describe 'materials query' do
    it 'returns a list of materials with basic fields' do
      user = create(:user)
      author = create(:person)
      create(:book, user: user, author: author, title: 'The Hobbit')

      query = <<~GRAPHQL
        query($page: Int, $perPage: Int) {
          materials(page: $page, perPage: $perPage) {
            id
            title
            status
            type
          }
        }
      GRAPHQL

      post '/graphql', params: { query:, variables: { page: 1, perPage: 10 } }

  expect(response).to have_http_status(:ok)
  json = JSON.parse(response.body)
  data = json['data']
  warn("GraphQL errors: #{json['errors'].inspect}") if data.nil?
      expect(data).to be_present
      expect(data['materials']).to be_an(Array)
      expect(data['materials'].first['title']).to eq('The Hobbit')
    end
  end

  describe 'material query' do
    it 'returns a single material by id' do
      user = create(:user)
      author = create(:person)
      material = create(:book, user: user, author: author, title: 'Silmarillion')

      query = <<~GRAPHQL
        query($id: ID!) {
          material(id: $id) {
            id
            title
            type
          }
        }
      GRAPHQL

      post '/graphql', params: { query:, variables: { id: material.id } }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      data = json['data']
      expect(data['material']['title']).to eq('Silmarillion')
      expect(data['material']['type']).to eq('Book')
    end
  end
end
