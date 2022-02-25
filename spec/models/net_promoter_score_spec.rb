# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NetPromoterScore, type: :model do
  subject { FactoryBot.build(:net_promoter_score) }

  it_should_behave_like 'a net promoter score'
end
