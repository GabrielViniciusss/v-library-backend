class Api::InstitutionsController < ApplicationController
    
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  before_action :set_institution, only: [:show, :update, :destroy]

  # GET /api/institutions
  def index
    @institutions = Institution.all
    render json: InstitutionSerializer.new(@institutions).serializable_hash
  end

  # GET /api/institutions/:id
  def show
    render json: InstitutionSerializer.new(@institution).serializable_hash
  end

  # POST /api/institutions
  def create
    @institution = Institution.new(institution_params)

    if @institution.save
      render json: InstitutionSerializer.new(@institution).serializable_hash, status: :created
    else
      render json: { errors: @institution.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /api/institutions/:id
  def update
    if @institution.update(institution_params)
      render json: InstitutionSerializer.new(@institution).serializable_hash, status: :ok
    else
      render json: { errors: @institution.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/institutions/:id
  def destroy
    @institution.destroy
    head :no_content
  end

  private

  def set_institution
    @institution = Institution.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Institution not found" }, status: :not_found
  end

  def institution_params
    params.require(:institution).permit(:name, :city)
  end
end