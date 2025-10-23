class Book < Material # Herda Material
  # Cenário 1: Criação via ISBN. O ISBN é a única coisa obrigatória.
  validates :isbn, 
            presence: true, 
            length: { is: 13 }, 
            numericality: { only_integer: true }, 
            uniqueness: true,
            if: -> { title.blank? } # Só valida o ISBN se não houver título manual

  # Cenário 2: Criação Manual. O Título é obrigatório.
  validates :title, 
            presence: true,
            if: -> { isbn.blank? } # Só valida o título se não houver ISBN

  # As páginas são sempre obrigatórias em ambos os cenários.
  validates :pages, presence: true, numericality: { only_integer: true, greater_than: 0 }
end