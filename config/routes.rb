# config/routes.rb
Rails.application.routes.draw do

  mount Rswag::Ui::Engine => '/api-docs' # monta a interface do Swagger
  mount Rswag::Api::Engine => '/api-docs'

  # Configuração do Devise
  scope 'api/' do
    devise_for :users,                   # cria rotas para o modelo User, com algumas regras
               path: '',                 # remove o prefixo 'users' das rotas
               path_names: {          
                 sign_in: 'login',
                 sign_out: 'logout',     # personaliza os nomes das rotas
                 registration: 'signup'
               },
               controllers: {
                 sessions: 'api/users/sessions',         # aponta para controladores customizados (arquivos do nosso)
                 registrations: 'api/users/registrations'
               }

    resources :people         # Adiciona as 7 rotas RESTful padrão 
    resources :institutions
  end

  root "application#index"
end