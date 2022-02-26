# frozen_string_literal: true

class NetPromoterScoreController < ActionController::Base
  before_action :authenticate, only: %i[index]
  before_action :set_net_promoter_score, only: %i[update]

  def index
    return head :no_content if net_promoter_score_index_params[:touchpoint].nil?

    nps_result = NetPromoterScore.where(touchpoint: net_promoter_score_index_params[:touchpoint])
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
    params.permit(:touchpoint)
  end

  def authenticate
    http_basic_authenticate_or_request_with(name: ENV['HTTP_BASIC_AUTH_USER'],
                                            password: ENV['HTTP_BASIC_AUTH_PASSWORD'])
  end
end
