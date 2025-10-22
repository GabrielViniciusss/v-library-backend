class Api::Users::SessionsController < Devise::SessionsController
  protect_from_forgery with: :null_session

  # Sobrescreve o método 'create' da gem
  def create
    # O 'warden' é o "segurança" (middleware) que o Devise usa por baixo dos panos.
    # 'authenticate!' tenta encontrar um usuário com os parâmetros de 'auth_options'
    # Se falhar (senha errada), ele automaticamente retorna um erro 401 (Não Autorizado)
    self.resource = warden.authenticate!(auth_options)

    # Se o 'authenticate!' passar, significa que o usuário é válido.
    
    # 'sign_in' é um método do Devise que registra o login
    sign_in(resource_name, resource)

    # O 'devise-jwt' detecta que o 'sign_in' aconteceu e, como configuramos
    # no 'devise.rb', ele AUTOMATICAMENTE anexa o Token JWT no cabeçalho
    # 'Authorization' da resposta.

    # Agora, retornamos um JSON de sucesso com os dados do usuário.
    render json: {
      status: { code: 200, message: 'Logged in successfully.' },
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
    }
  end

  # Sobrescreve o método 'destroy' da gem
  def destroy
    # 'current_user' é um método do Devise que encontra o usuário
    # através do Token JWT enviado na requisição
    if current_user
      # 'sign_out' é o método do Devise para fazer logout
      sign_out(resource_name)
      render json: {
        status: { code: 200, message: 'Logged out successfully.' }
      }, status: :ok
    else
      render json: {
        status: { code: 401, message: "Couldn't find an active session." }
      }, status: :unauthorized
    end
  end
end