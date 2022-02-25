# frozen_string_literal: true

class CreateNetPromoterScores < ActiveRecord::Migration[6.1]
  def up
    create_enum 'touchpoint_type',       %w[pending]
    create_enum 'respondent_class_type', %w[Pending]
    create_enum 'scorable_class_type', %w[Pending]

    create_table :net_promoter_scores do |t|
      t.integer :score
      t.string  :type
      t.string  :token,            null: false
      t.enum    :touchpoint,       as: 'touchpoint_type',       default: 'pending', null: false
      t.enum    :respondent_class, as: 'respondent_class_type', default: 'Pending', null: false
      t.enum    :scorable_class,   as: 'scorable_class_type', default: 'Pending', null: false
      t.bigint  :respondent_id,    null: false
      t.bigint  :scorable_id,      null: false
      t.timestamps

      # Using indices adds an extra layer of protection (against race conditions) compared to Rails validations
      t.index %i[touchpoint
                 respondent_id
                 respondent_class
                 scorable_id
                 scorable_class], unique: true, name: 'unique_touchpoint'
      t.check_constraint 'score IN (NULL, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)', name: 'check_score_decimal_scale'
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
