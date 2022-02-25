# frozen_string_literal: true

FactoryBot.define do
  factory :property_sell do
    touchpoint       { 'realtor_feedback' }
    respondent_class { 'Seller' }
    object_class     { 'Realtor' }
    object_id        { 1 }
    respondent_id    { 1 }
  end
end
