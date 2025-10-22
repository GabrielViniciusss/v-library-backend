# O nome da classe DEVE bater com o caminho
class Api::PeopleController < ApplicationController

  # chama authenticate_user penas para as ações de escrita (create, update, destroy). 
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  # Chama o método 'set_person' (definido abaixo) antes de as ações show, update e destroy
  before_action :set_person, only: [:show, :update, :destroy]

  # GET /api/people
  def index
    @people = Person.all
    render json: PersonSerializer.new(@people).serializable_hash
  end

  # GET /api/people/:id
  def show
    render json: PersonSerializer.new(@person).serializable_hash
  end

  # POST /api/people
  def create
    @person = Person.new(person_params)

    if @person.save
      render json: PersonSerializer.new(@person).serializable_hash, status: :created
    else
      render json: { errors: @person.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /api/people/:id
  def update
    if @person.update(person_params)
      render json: PersonSerializer.new(@person).serializable_hash, status: :ok
    else
      render json: { errors: @person.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/people/:id
  def destroy
    @person.destroy
    head :no_content
  end

  private

  def set_person
    @person = Person.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Person not found" }, status: :not_found
  end

  def person_params
    params.require(:person).permit(:name, :date_of_birth)
  end
end