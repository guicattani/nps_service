class PropertySell < NetPromoterScore
  validate :respondent_class_type, inclusion: { in: %i[Seller Buyer]}
  validate :object_class_type,     inclusion: { in: %i[Realtor HomedayService]}

  validate :touchpoint_type, inclusion: { in: %i[realtor_feedback] },         if: Proc.new { object_class_type == Realtor }
  validate :touchpoint_type, inclusion: { in: %i[homeday_service_feedback] }, if: Proc.new { object_class_type == HomedayService }
end
