
class Api::BooksController < ApplicationController

  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_book, only: [:show, :update, :destroy]

  # GET /api/books
  def index
    @books = Book.all
    render json: BookSerializer.new(@books).serializable_hash
  end

  # GET /api/books/:id
  def show
    render json: BookSerializer.new(@book).serializable_hash
  end

  # POST /api/books
  def create
    @book = Book.new(book_params)

    # 1. Define o 'criador' como o usuário logado
    @book.user = current_user 

    # 2. Autoriza a ação (Pundit vai chamar MaterialPolicy#create?)
    authorize @book

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