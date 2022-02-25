# frozen_string_literal: true

FactoryBot.define do
  factory :property_sell do
    touchpoint       { 'realtor_feedback' }
    respondent_class { 'Seller' }
    object_class     { 'Realtor' }
  end
end
