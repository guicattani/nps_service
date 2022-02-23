class NetPromoterScore < ApplicationRecord
  validates :respondent_id, uniqueness: { scope: :respondent_class }
  validates :object_id,     uniqueness: { scope: :object_class }
  validates :touchpoint,    uniqueness: { scope: %i[object_id object_class respondent_id respondent_class] }

  has_secure_token :token, length: 50
end
