# frozen_string_literal: true

class PropertySell < NetPromoterScore
  validates :respondent_class, inclusion: { in: allowed_classes(%w[Seller Buyer]) }
  validates :object_class,     inclusion: { in: allowed_classes(%w[Realtor HomedayService]) }

  validates :touchpoint, inclusion: { in: %w[realtor_feedback] },         if: proc { object_class == 'Realtor' }
  validates :touchpoint, inclusion: { in: %w[homeday_service_feedback] }, if: proc { object_class == 'HomedayService' }
end
