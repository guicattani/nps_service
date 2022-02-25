# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateNetPromoterScoreWorker do
  let(:valid_property_sell_payload) do
    [
      {
        type: 'PropertySell',
        touchpoint: 'realtor_feedback',
        respondent_class: 'Seller',
        scorable_class: 'Realtor',
        respondent_id: 1,
        scorable_id: 1
      }
    ]
  end
  let(:invalid_property_sell_payload) do
    valid_property_sell_payload.first[:touchpoint] = 'invalid_touchpoint'
    valid_property_sell_payload
  end

  context 'work' do
    after(:each) { NetPromoterScore.delete_all }

    context 'trough a published event' do
      context 'valid params' do
        it 'creates a NetPromoterScore type class' do
          publisher = CreateNetPromoterScoreTestPublisher.new
          publisher.payload = valid_property_sell_payload
          expect(NetPromoterScore.all.reload.count).to eq(0)
          publisher.publish
          sleep 0.3
          expect(NetPromoterScore.all.reload.count).to eq(1)
        end
      end

      context 'invalid params' do
        it 'does not create a NetPromoterScore type class' do
          publisher = CreateNetPromoterScoreTestPublisher.new
          publisher.payload = invalid_property_sell_payload
          expect(NetPromoterScore.all.reload.count).to eq(0)
          publisher.publish
          sleep 0.3
          expect(NetPromoterScore.all.reload.count).to eq(0)
        end
      end
    end
  end
end
