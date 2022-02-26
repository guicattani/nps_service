# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PropertySell, type: :model do
  subject { FactoryBot.build(:property_sell, scorable_class: 'Realtor', touchpoint: 'realtor_feedback') }

  it_should_behave_like 'a net promoter score'

  context 'validation of inclusion scopes' do
    context 'scorable class is Realtor' do
      it 'allows for realtor related touchpoints' do
        expect(subject).to be_valid

        subject.scorable_class = 'HomedayService'
        expect(subject).not_to be_valid
      end
    end
    context 'scorable class is HomedayService' do
      it 'allows for Homeday related touchpoints' do
        subject.scorable_class = 'HomedayService'
        subject.touchpoint = 'homeday_service_feedback'
        expect(subject).to be_valid

        subject.scorable_class = 'Realtor'
        expect(subject).not_to be_valid
      end
    end
  end
end
