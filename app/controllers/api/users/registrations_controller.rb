class Api::Users::RegistrationsController < Devise::RegistrationsController  #herda controller de Registro que já vem na gem devise

  def create
    # 'build_resource' é um método do Devise que cria um novo usuário (ex: User.new) com os parâmetros seguros (sign_up_params)
    build_resource(sign_up_params)

    if resource.save
      render json: {
        status: { code: 200, message: 'Signed up successfully.' },
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: {
          code: 422, # 422 (Unprocessable Entity) é o status HTTP padrão para falha de validação
          message: "User couldn't be created successfully.",
          errors: resource.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  private # Métodos abaixo só podem ser chamados dentro deste arquivo

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end