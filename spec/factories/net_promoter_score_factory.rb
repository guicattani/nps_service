# frozen_string_literal: true

FactoryBot.define do
  factory :net_promoter_score do
    touchpoint       { 'pending' }
    respondent_class { 'Pending' }
    scorable_class   { 'Pending' }
    scorable_id      { 1 }
    respondent_id    { 1 }
  end
end
