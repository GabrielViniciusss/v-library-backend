# spec/factories/materials.rb
FactoryBot.define do
  factory :material do
    title { "Um Título de Teste" }
    status { 'published' } # Certifique-se que 'published' é uma chave válida no seu enum

    association :user
    association :author, factory: :person

    # "trait" para um livro
    trait :book do
      type { 'Book' }
      # --- CORREÇÃO AQUI ---
      # Define a sequência diretamente
      sequence(:isbn) { |n| "9780321764#{n.to_s.rjust(3, '0')}" }
      # ----------------------
      pages { 100 }
    end

    # "trait" para um artigo
    trait :article do
      type { 'Article' }
      # --- CORREÇÃO AQUI ---
      sequence(:doi) { |n| "10.1000/xyz#{n}" }
      # ----------------------
    end

    # "trait" para um vídeo
    trait :video do
      type { 'Video' }
      duration_in_minutes { 60 }
    end

    # Atalhos de fábrica
    factory :book, traits: [:book]
    factory :article, traits: [:article]
    factory :video, traits: [:video]
  end
end