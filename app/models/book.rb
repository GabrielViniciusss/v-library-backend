class Book < Material # Herda Material
  validates :isbn, presence: true, length: { is: 13 }, numericality: { only_integer: true }

  validates :isbn, uniqueness: true

  validates :pages, presence: true, numericality: { only_integer: true, greater_than: 0 }
end