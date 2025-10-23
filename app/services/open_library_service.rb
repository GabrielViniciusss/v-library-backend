require 'faraday'
require 'json'

class OpenLibraryService
  BASE_URL = 'https://openlibrary.org'

  def initialize(isbn)
    @isbn = isbn
  end

  # O método principal que nosso controller vai chamar
  def fetch_book_data
    conn = Faraday.new(url: BASE_URL)

    response = conn.get('/api/books') do |req|
      req.params['bibkeys'] = "ISBN:#{@isbn}"
      req.params['format'] = 'json'
      req.params['jscmd'] = 'data'
    end

    return parse_response(response)

  rescue Faraday::Error => e
    Rails.logger.error "OpenLibraryService Error: #{e.message}"
    return nil 
  end

  private

  def parse_response(response)
    return nil unless response.success? && response.body.present?

    # Converte o corpo da resposta de JSON para um Hash Ruby
    data = JSON.parse(response.body)

    return nil if data.empty?

    # A API da OpenLibrary retorna um JSON aninhado Ex: { "ISBN:9780140328721": { "title": "...", "number_of_pages": ... } }
    book_data = data["ISBN:#{@isbn}"]

    return nil unless book_data

    {
      title: book_data['title'],
      pages: book_data['number_of_pages']
    }
  end
end