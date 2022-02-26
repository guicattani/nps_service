# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "NetPromoterScore", type: :request do
  let!(:net_promoter_score) { FactoryBot.create(:property_sell) }

  describe "GET /index" do
    let!(:net_promoter_score2) do
      FactoryBot.create(:property_sell, scorable_class: 'HomedayService', touchpoint: 'homeday_service_feedback')
    end
    let(:net_promoter_score3) do
      FactoryBot.build(:property_sell, scorable_class: 'HomedayService',
                                       touchpoint: 'homeday_service_feedback', respondent_class: 'Buyer')
    end

    context 'logged in' do
      before do
        http_login
      end
      context 'with touchpoint param' do
        it 'returns all net promoter scores filtered by touchpoint' do
          get net_promoter_score_index_path, params: { touchpoint: 'realtor_feedback' }, headers: @headers
          expect(response).to have_http_status(:ok)
          expect(response.body).not_to be_empty
          expect(parsed_response.to_s).to include(net_promoter_score.token)
          expect(parsed_response.to_s).not_to include(net_promoter_score2.token)
        end

        it 'filters by scorable_class' do
          get net_promoter_score_index_path,
              params: { touchpoint: 'homeday_service_feedback', scorable_class: 'HomedayService' }, headers: @headers
          expect(response).to have_http_status(:ok)
          expect(response.body).not_to be_empty
          expect(parsed_response.to_s).to include(net_promoter_score2.token)
          expect(parsed_response.to_s).not_to include(net_promoter_score.token)
        end

        it 'filters by respondent_class' do
          net_promoter_score3.save
          get net_promoter_score_index_path,
              params: { touchpoint: 'homeday_service_feedback',
                        scorable_class: 'HomedayService',
                        respondent_class: 'Buyer' }, headers: @headers
          expect(response).to have_http_status(:ok)
          expect(response.body).not_to be_empty
          expect(parsed_response.to_s).to include(net_promoter_score3.token)
          expect(parsed_response.to_s).not_to include(net_promoter_score2.token)
        end
      end
      context 'without touchpoint param' do
        it 'returns no content' do
          get net_promoter_score_index_path, params: { scorable_class: 'HomedayService' }, headers: @headers
          expect(response).to have_http_status(:no_content)
        end
      end
    end

    context 'not logged in' do
      it 'returns unauthorized status' do
        get net_promoter_score_index_path, params: { touchpoint: 'realtor_feedback' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /update/:token" do
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
