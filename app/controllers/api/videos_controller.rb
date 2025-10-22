class Api::VideosController < ApplicationController

  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_video, only: [:show, :update, :destroy]


  # GET /api/videos
  def index
    @videos = Video.page(params[:page]).per(10)

    options = {
      meta: {
        total_pages: @videos.total_pages,
        total_count: @videos.total_count,
        current_page: @videos.current_page
      }
    }

    render json: VideoSerializer.new(@videos,options).serializable_hash
  end

  # GET /api/videos/:id
  def show
    render json: VideoSerializer.new(@video).serializable_hash
  end

  # POST /api/videos
  def create
    @video = Video.new(video_params)
    @video.user = current_user 

    authorize @video

    if @video.save
      render json: VideoSerializer.new(@video).serializable_hash, status: :created
    else
      render json: { errors: @video.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /api/videos/:id
  def update
    authorize @video

    if @video.update(video_params)
      render json: VideoSerializer.new(@video).serializable_hash, status: :ok
    else
      render json: { errors: @video.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/videos/:id
  def destroy
    authorize @video

    @video.destroy
    head :no_content
  end

  private

  def set_video
    @video = Video.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Video not found" }, status: :not_found
  end

  def video_params
    params.require(:video).permit(
      :title, 
      :description, 
      :status, 
      :author_id,    
      :author_type,  
      :duration_in_minutes 
    )
  end
end