class RoboscoutQueriesController < ApplicationController
  before_action :set_roboscout_query, only: [:show, :update, :destroy, :people]

  # GET /roboscout_queries
  def index
    @roboscout_queries = RoboscoutQuery.all
    render json: @roboscout_queries
  end

  # GET /roboscout_queries/1
  def show
    render json: @roboscout_query
  end

  # POST /roboscout_queries
  def create
    @roboscout_query = RoboscoutQuery.new(roboscout_query_params)

    if @roboscout_query.save
      StartRoboscoutQueryJob.perform_later(@roboscout_query.id)
      render json: @roboscout_query, status: :created
    else
      render json: @roboscout_query.errors, status: :unprocessable_entity
    end
  end

  # GET /roboscout_queries/1/people
  def people
    roboscout_query = RoboscoutQuery.find(params[:id])
    people = roboscout_query.people.includes(:publications)

    # Calculate relevance score for each person
    people_with_scores = people.map do |person|
      relevance_score = person.publications.sum { |pub| 1.0 / pub.position }
      person.attributes.merge(relevance_score: relevance_score)
    end

    # Sort people by relevance score in descending order
    sorted_people = people_with_scores.sort_by { |p| -p[:relevance_score] }

    render json: sorted_people
  end

  private

  def set_roboscout_query
    @roboscout_query = RoboscoutQuery.find(params[:id])
  end

  def roboscout_query_params
    params.require(:roboscout_query).permit(:query)
  end
end
