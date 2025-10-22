class Article < Material
  DOI_REGEX = /\A10\.\d{4,9}\/[-._;()\/:A-Z0-9]+\z/i
  # Garante que o DOI seja único, obrigatório e siga o formato regex 
  validates :doi, presence: true, 
                  uniqueness: true, 
                  format: { with: DOI_REGEX, message: 'invalid format' }
end