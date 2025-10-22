class Institution < ApplicationRecord
  has_many :materials, as: :author

  validates :name, presence: true, length: { minimum: 3, maximum: 120 }
  validates :city, presence: true, length: { minimum: 2, maximum: 80 }
end