# frozen_string_literal: true

FactoryBot.define do
  factory :net_promoter_score do
    touchpoint       { 'pending' }
    respondent_class { 'Pending' }
    object_class     { 'Pending' }
  end
end
