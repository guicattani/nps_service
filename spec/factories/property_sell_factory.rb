# frozen_string_literal: true

FactoryBot.define do
  factory :property_sell do
    touchpoint       { 'realtor_feedback' }
    respondent_class { 'Seller' }
    scorable_class   { 'Realtor' }
    scorable_id      { 1 }
    respondent_id    { 1 }
  end
end
