class PublicationsController < ApplicationController
  before_action :set_publication, only: [:show, :update, :destroy]

  # GET /publications
  def index
    @publications = Publication.all
    render json: @publications
  end

  # GET /publications/1
  def show
    render json: @publication
  end

  # POST /publications
  def create
    @publication = Publication.new(publication_params)

    if @publication.save
      render json: @publication, status: :created
    else
      render json: @publication.errors, status: :unprocessable_entity
    end
  end

  private

  def set_publication
    @publication = Publication.find(params[:id])
  end

  def publication_params
    params.require(:publication).permit(:title, :abstract, :publication_date, :openalex_id, :position)
  end
end
