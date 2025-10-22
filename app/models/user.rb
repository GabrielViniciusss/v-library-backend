# app/models/user.rb

class User < ApplicationRecord

  has_many :materials
  
  # Devise já valida email (formato, unicidade) e senha (mínimo de 6) por padrão através do módulo :validatable.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null 
  
end