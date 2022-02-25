# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PropertySell, type: :model do
  subject { FactoryBot.build(:property_sell) }

  it_should_behave_like 'a net promoter score'
end
