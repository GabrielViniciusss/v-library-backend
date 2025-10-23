
class Api::BooksController < ApplicationController

  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_book, only: [:show, :update, :destroy]

  # GET /api/books
  def index
    @books = Book.page(params[:page]).per(10)

    options = {
      include: [:author], # Adiciona os dados do autor na resposta
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
    isbn = params.dig(:book, :isbn)

    if isbn.present?
      # --- Cenário 1: Criação via ISBN ---
      @book = Book.new(isbn: isbn, user: current_user, status: 'published')
      begin
        external_data = OpenLibraryService.new(isbn).fetch_book_data
        if external_data && external_data[:title]
          @book.title = external_data[:title]
          @book.pages = external_data[:pages]
          if external_data[:authors].present?
            author_name = external_data[:authors].first
            # Encontra ou inicializa o autor para poder adicionar a data de nascimento se for um novo registro
            author = Person.find_or_initialize_by(name: author_name)
            if author.new_record?
              author.date_of_birth = Date.new(1970, 1, 1) # Data padrão
              author.save!
            end
            @book.author = author
          end
        else
          @book.errors.add(:isbn, "was not found or returned incomplete data from the external library")
        end
      rescue => e
        Rails.logger.error "OpenLibraryService failed for ISBN #{isbn}: #{e.message}"
        @book.errors.add(:base, "An error occurred while fetching data for the given ISBN.")
      end
    else
      # --- Cenário 2: Criação Manual ---
      # Garante que apenas os parâmetros manuais sejam usados
      manual_params = book_params.except(:isbn)
      @book = Book.new(manual_params)
      @book.author_type = 'Person' if manual_params[:author_id].present? # Define o tipo para a associação polimórfica
      @book.user = current_user
    end

    authorize @book

    # A validação do modelo será executada no @book.save
    if @book.errors.empty? && @book.save
      render json: BookSerializer.new(@book).serializable_hash, status: :created
    else
      # Se o save falhar, os erros de validação do modelo serão adicionados.
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
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