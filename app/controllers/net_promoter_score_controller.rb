# frozen_string_literal: true

class NetPromoterScoreController < ApplicationController
  before_action :authenticate, only: %i[index]
  before_action :set_net_promoter_score, only: %i[update]

  def index
    return head :no_content if net_promoter_score_index_params[:touchpoint].nil?

    nps_result = NetPromoterScore.where(index_query_params)
    render json: nps_result.to_json, status: :ok
  end

  def update
    head :ok if @net_promoter_score.update(net_promoter_score_params)
  rescue ActiveRecord::StatementInvalid
    render json: { errors: 'score needs to be between 0 and 10' }, status: :unprocessable_entity
  end

  private

  def set_net_promoter_score
    @net_promoter_score = NetPromoterScore.find_by(token: params[:token])

    head :not_found unless @net_promoter_score
  end

  def net_promoter_score_params
    params.permit(:score)
  end

  def net_promoter_score_index_params
    params.permit(:touchpoint, :respondent_class, :scorable_class)
  end

  def index_query_params
    query = { touchpoint: net_promoter_score_index_params[:touchpoint] }

    unless net_promoter_score_index_params[:respondent_class].nil?
      query[:respondent_class] = net_promoter_score_index_params[:respondent_class]
    end

    unless net_promoter_score_index_params[:scorable_class].nil?
      query[:scorable_class] = net_promoter_score_index_params[:scorable_class]
    end

    query
  end

  def authenticate
    http_basic_authenticate_or_request_with(name: ENV['HTTP_BASIC_AUTH_USER'],
                                            password: ENV['HTTP_BASIC_AUTH_PASSWORD'])
  end
end
