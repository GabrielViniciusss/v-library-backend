class Api::SearchController < ApplicationController
  # GET /api/search
  def index
    # Pega o parâmetro da URL (ex: /api/search?q=ruby)
    query = params[:q]

    if query.blank?
      @materials = Material.none.page(params[:page]).per(10)
    else
      search_query = "%#{query}%"

      @materials = Material.left_outer_joins(
        "LEFT OUTER JOIN people ON people.id = materials.author_id AND materials.author_type = 'Person'"
      ).left_outer_joins(
        "LEFT OUTER JOIN institutions ON institutions.id = materials.author_id AND materials.author_type = 'Institution'"
      ).where(
        "materials.title ILIKE :q OR materials.description ILIKE :q OR people.name ILIKE :q OR institutions.name ILIKE :q",
        q: search_query
      ).page(params[:page]).per(10) 
    end

    options = {
      meta: {
        total_pages: @materials.total_pages,
        total_count: @materials.total_count,
        current_page: @materials.current_page
      }
    }

    # Usamos o MaterialSerializer (title, description, status, author) 
    render json: MaterialSerializer.new(@materials, options).serializable_hash
  end
end