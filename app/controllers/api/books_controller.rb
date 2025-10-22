
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

    # Pega o ISBN (se existir)
    isbn = local_book_params[:isbn]

    # Se o ISBN foi dado E (o título OU as páginas estão em branco)
    if isbn.present? && (local_book_params[:title].blank? || local_book_params[:pages].blank?)

      # chama service
      external_data = OpenLibraryService.new(isbn).fetch_book_data
      if external_data
        local_book_params[:title] = local_book_params[:title].presence || external_data[:title]
        local_book_params[:pages] = local_book_params[:pages].presence || external_data[:pages]
      end
    end

    @book = Book.new(local_book_params)

    @book.user = current_user # Define o criador
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