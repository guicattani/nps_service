# frozen_string_literal: true

class CreateNetPromoterScores < ActiveRecord::Migration[6.1]
  def up
    create_enum 'touchpoint_type',       %w[pending]
    create_enum 'respondent_class_type', %w[Pending]
    create_enum 'object_class_type',     %w[Pending]

    create_table :net_promoter_scores do |t|
      t.integer :score
      t.string  :type
      t.string  :token,            null: false
      t.enum    :touchpoint,       enum_type: 'touchpoint_type',       default: 'pending'
      t.enum    :respondent_class, enum_type: 'respondent_class_type', default: 'Pending'
      t.enum    :object_class,     enum_type: 'object_class_type',     default: 'Pending'
      t.bigint  :respondent_id
      t.bigint  :object_id
      t.timestamps

      t.index :respondent_id, unique: true
      t.index :object_id,     unique: true
      t.check_constraint 'score IN (NULL, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)', name: 'check_score_decimal_scale'
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
