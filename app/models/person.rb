class Person < ApplicationRecord

  has_many :materials, as: :author
  
  validate :date_of_birth_cannot_be_in_the_future

  validates :name, presence: true, length: { minimum: 3, maximum: 80 } # nome obrigatorio de no minimo 3 caracteres e no máximo 80
  validates :date_of_birth, presence: true                             # data de nascimento obrigatoria

  # validate = validação customizada
  # validates = validacoes prontas do Rails (presence, length, etc)
  private

  def date_of_birth_cannot_be_in_the_future
    if date_of_birth.present? && date_of_birth > Date.today
      errors.add(:date_of_birth, "date of birth can't be in the future")
    end
  end
end