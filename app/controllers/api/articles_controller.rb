class Api::ArticlesController < ApplicationController

  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_article, only: [:show, :update, :destroy]

  # GET /api/articles
  def index
    @articles = Article.page(params[:page]).per(10)

    options = {
      meta: {
        total_pages: @articles.total_pages,
        total_count: @articles.total_count,
        current_page: @articles.current_page
      }
    }

    render json: ArticleSerializer.new(@articles, options).serializable_hash
  end

  # GET /api/articles/:id
  def show
    render json: ArticleSerializer.new(@article).serializable_hash
  end

  # POST /api/articles
  def create
    @article = Article.new(article_params)
    @article.user = current_user # Define o criador

    authorize @article

    if @article.save
      render json: ArticleSerializer.new(@article).serializable_hash, status: :created
    else
      render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /api/articles/:id
  def update
    # Falha se o current_user não for o criador (@article.user)
    authorize @article

    if @article.update(article_params)
      render json: ArticleSerializer.new(@article).serializable_hash, status: :ok
    else
      render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/articles/:id
  def destroy
    authorize @article

    @article.destroy
    head :no_content
  end

  private

  def set_article
    @article = Article.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Article not found" }, status: :not_found
  end

  def article_params
    params.require(:article).permit(
      :title, 
      :description, 
      :status, 
      :author_id,    
      :author_type,  
      :doi           
    )
  end
end