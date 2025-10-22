# app/models/user.rb

class User < ApplicationRecord
  # Devise já valida email (formato, unicidade) e senha (mínimo de 6) por padrão através do módulo :validatable.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
end