# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a net promoter score' do
  context 'validations' do
    it { should validate_uniqueness_of(:respondent_id).scoped_to(:respondent_class) }
  end
end
