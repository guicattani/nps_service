# frozen_string_literal: true

class AddEnumValuesOfPropertySell < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    # Can't use %i[...] here because of no support in PGEnum
    add_enum_value 'touchpoint_type',       :realtor_feedback,         after: 'pending'
    add_enum_value 'touchpoint_type',       :homeday_service_feedback, after: 'pending'

    add_enum_value 'respondent_class_type', :Seller, after: 'Pending'
    add_enum_value 'respondent_class_type', :Buyer,  after: 'Pending'

    add_enum_value 'object_class_type',     :Realtor,        after: 'Pending'
    add_enum_value 'object_class_type',     :HomedayService, after: 'Pending'
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
