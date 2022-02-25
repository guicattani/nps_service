# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "NetPromoterScore", type: :request do
  let(:net_promoter_score) { FactoryBot.create(:property_sell) }

  describe "GET /update" do
    context 'valid token' do
      context 'valid score' do
        it 'updates the submission correctly' do
          expect do
            put "/net_promoter_score/#{net_promoter_score.token}", params: { score: 5 }
            net_promoter_score.reload
          end.to change { net_promoter_score.score }.to(5)
          expect(response).to have_http_status(:ok)
        end
      end

      context 'invalid score' do
        it 'returns unprocessable entity' do
          expect do
            put "/net_promoter_score/#{net_promoter_score.token}", params: { score: -10 }
            net_promoter_score.reload
          end.not_to(change { net_promoter_score.score })
        end
      end
    end
  end
end
