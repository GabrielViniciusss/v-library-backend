require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

require 'database_cleaner/active_record'
require 'factory_bot_rails'


Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  config.use_transactional_fixtures = false
  # métodos do FactoryBot (ex: create(:user) em vez de FactoryBot.create(:user))
  config.include FactoryBot::Syntax::Methods
  # Limpa o banco (estratégia de "truncation") antes de toda a suíte de testes
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :truncation
  end

  # 'around' é melhor que 'before' e 'after'
  # Ele "envolve" o teste: limpa, roda o teste, limpa de novo.
  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.filter_rails_from_backtrace!
end
