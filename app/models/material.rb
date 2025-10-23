# app/models/material.rb

class Material < ApplicationRecord
  belongs_to :user
  
  # Conexão polimórfica com o Autor (pode ser Person ou Institution)
  belongs_to :author, polymorphic: true
  
  enum status: { 
    draft: 'rascunho', 
    published: 'publicado', 
    archived: 'arquivado' 
  }

  # A validação do título será movida para os modelos filhos (Book, etc.)
  # para permitir lógicas condicionais mais complexas.
  validates :title, length: { minimum: 3, maximum: 100 }, allow_blank: true
  validates :description, length: { maximum: 1000 }, allow_blank: true 
  
  # Garante que o status seja um dos valores definidos no 'enum'
  validates :status, presence: true, inclusion: { in: statuses.keys } 
  
  # Garante que as associações obrigatórias existam
  validates :user, presence: true 
  validates :author, presence: true
  
  def policy_class
    MaterialPolicy
  end
  
end