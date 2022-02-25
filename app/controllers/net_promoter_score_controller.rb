# frozen_string_literal: true

class NetPromoterScoreController < ApplicationController
  before_action :set_net_promoter_score, before: %i[update]

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
end
