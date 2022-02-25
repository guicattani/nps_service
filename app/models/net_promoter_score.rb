# frozen_string_literal: true

# STI class, shouldn't be used without type
class NetPromoterScore < ApplicationRecord
  validates :touchpoint, uniqueness: { scope: %i[object_id object_class respondent_id respondent_class] }
  has_secure_token :token, length: 50

  def self.allowed_classes(classes)
    return classes << 'Test' if Rails.env.test?

    classes
  end
end
