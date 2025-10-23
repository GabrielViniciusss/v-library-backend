
class Api::BooksController < ApplicationController

  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_book, only: [:show, :update, :destroy]

  # GET /api/books
  def index
    @books = Book.page(params[:page]).per(10)

    options = {
      meta: {
        total_pages: @books.total_pages,
        total_count: @books.total_count,
        current_page: @books.current_page
      }
    }

    render json: BookSerializer.new(@books,options).serializable_hash
  end

  # GET /api/books/:id
  def show
    render json: BookSerializer.new(@book).serializable_hash
  end

  # POST /api/books
  def create
    local_book_params = book_params
    isbn = local_book_params[:isbn]

    @book = Book.new(local_book_params)
    @book.user = current_user # Define o criador

    # Cenário 1: Criação via ISBN
    if isbn.present?
      begin
        external_data = OpenLibraryService.new(isbn).fetch_book_data
        if external_data
          @book.title = @book.title.presence || external_data[:title]
          @book.pages = @book.pages.presence || external_data[:pages]

          if external_data[:authors].present?
            author_name = external_data[:authors].first
            # Encontra ou cria o autor e o associa ao livro
            @book.author = Person.find_or_create_by(name: author_name)
          end
        end
      rescue => e
        # Se a busca externa falhar, registra o erro, mas não impede a criação do livro.
        # O livro será criado apenas com os dados fornecidos manualmente (se houver).
        Rails.logger.error "OpenLibraryService failed for ISBN #{isbn}: #{e.message}"
      end
    end
    # Se não houver ISBN, o @book já foi inicializado com os parâmetros manuais (incluindo author_id)
    # e a associação de autor funcionará se o author_id for válido.

    authorize @book # Pundit verifica MaterialPolicy#create?

    if @book.save
      render json: BookSerializer.new(@book).serializable_hash, status: :created # 201
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity # 422
    end
  end

  # PUT /api/books/:id
  def update

    # 1. Autoriza a ação (Pundit vai chamar MaterialPolicy#update?), se 'current_user' não for '@book.user', o Pundit vai falhar aqui.
    authorize @book

    if @book.update(book_params)
      render json: BookSerializer.new(@book).serializable_hash, status: :ok # 200
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity # 422
    end
  end

  # DELETE /api/books/:id
  def destroy

    authorize @book

    @book.destroy
    head :no_content # 204
  end

  private

  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Book not found" }, status: :not_found # 404
  end

  def book_params
    params.require(:book).permit(
      :title, 
      :description, 
      :status, 
      :author_id,    
      :author_type,  
      :isbn,         
      :pages         
    )
  end
end