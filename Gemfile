# Gemfile

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails", "~> 7.1.0"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "image_processing", "~> 1.2"

# gems para lidar com CORS
gem "rack-cors"

# gems para autenticação
gem "devise"
gem "devise-jwt"

# gem para Permissões 
gem "pundit"

# gem para Paginação 
gem "kaminari"

# gem para Consumo de API Externa 
gem "faraday"

# gems para GraphQL e Swagger
gem "graphql"
gem "rswag-api"
gem "rswag-ui"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false

  # gems de testes
  gem "rspec-rails"       # framework de testes
  gem "factory_bot_rails" # Para criar dados de teste
  gem "faker"             # Para gerar dados falsos
  gem "rswag-specs"       # Para gerar specs do Swagger
end

