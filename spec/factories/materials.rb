# spec/factories/materials.rb
FactoryBot.define do
  factory :material do
    title { "Um Título de Teste" }
    status { 'published' }

    # Associações: cria um usuário e uma pessoa por padrão
    association :user
    association :author, factory: :person

    # "trait" para um livro
    trait :book do
      type { 'Book' }
      isbn { sequence(:isbn) { |n| "9780321764#{n.to_s.rjust(3, '0')}" } } # Gera ISBN único
      pages { 100 }
    end

    # "trait" para um artigo
    trait :article do
      type { 'Article' }
      doi { sequence(:doi) { |n| "10.1000/xyz#{n}" } } # Gera DOI único
    end

    # "trait" para um vídeo
    trait :video do
      type { 'Video' }
      duration_in_minutes { 60 }
    end

    # Atalhos de fábrica: 'create(:book)' em vez de 'create(:material, :book)'
    factory :book, traits: [:book]
    factory :article, traits: [:article]
    factory :video, traits: [:video]
  end
end