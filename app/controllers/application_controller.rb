class ApplicationController < ActionController::API

  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # Este método 'index' responde à rota 'root "application#index"' que definimos no 'routes.rb'. É uma "página inicial" para a nossa API.
  def index
    render json: { message: 'Welcome to the v-library-backend API' }
  end

  # 'protected' significa que estes métodos podem ser chamados
  # por esta classe e por qualquer classe que herde dela (nossos
  # futuros controllers), mas não podem ser chamados como rotas/actions.
  protected

  # Método no início de qualquer controller que precise de autenticação
  def authenticate_user!
    # 'authenticate!(:jwt, scope: :user)' faz o seguinte:
    # 1. Procura o 'Authorization' header na requisição.
    # 2. Tenta validar o Token JWT (usando nossa 'jwt.secret').
    # 3. Se o token for válido, ele encontra o usuário e continua.
    # 4. Se o token for INVÁLIDO ou AUSENTE, ele lança um erro.
    warden.authenticate!(:jwt, scope: :user)
  
  rescue => e
    render json: {
      status: { code: 401, message: 'Not authenticated.', errors: e.message }
    }, status: :unauthorized
  end


  # 'current_user' vai pegar o objeto do usuário logado (autenticado)
  def current_user
    warden.user(scope: :user)
  end

  private

  def user_not_authorized
    render json: {
      status: { code: 403, message: 'Forbidden. You do not have permission to perform this action.' }
    }, status: :forbidden
  end

end