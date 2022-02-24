# frozen_string_literal: true

class PropertySell < NetPromoterScore
  validates :respondent_class_type, inclusion: { in: %i[Seller Buyer] }
  validates :object_class_type,     inclusion: { in: %i[Realtor HomedayService] }

  validates :touchpoint_type, inclusion: { in: %i[realtor_feedback] }, if: proc {
                                                                             object_class_type == Realtor
                                                                           }
  validates :touchpoint_type, inclusion: { in: %i[homeday_service_feedback] }, if: proc {
                                                                                     object_class_type == HomedayService
                                                                                   }
end
