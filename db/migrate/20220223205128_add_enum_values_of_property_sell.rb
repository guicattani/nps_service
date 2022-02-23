class AddEnumValuesOfPropertySell < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    add_enum_value 'touchpoint_type',       %i[realtor_feedback homeday_service_feedback], after: 'pending'
    add_enum_value 'respondent_class_type', %i[Seller Buyer], after: 'Pending'
    add_enum_value 'object_class_type',     %i[Realtor HomedayService], after: 'Pending'
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
