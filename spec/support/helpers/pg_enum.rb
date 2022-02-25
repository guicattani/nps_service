# frozen_string_literal: true

# Create a new enum type. Used for validation checking without messing with migrations
def create_enum_type(enum_type, new_type, after = 'pending')
  ActiveRecord::Base.connection.execute(
    create_enum_type_sql(enum_type, new_type, after)
  )
end

# SQL to create a new enum type on the database, ignores if the type already exists
def create_enum_type_sql(enum_type, new_type, after)
  "DO $$
    BEGIN
      ALTER TYPE #{enum_type}_type ADD VALUE '#{new_type}' AFTER '#{after}';
    EXCEPTION
      WHEN duplicate_object THEN null;
   END$$;"
end
## Source https://stackoverflow.com/a/48382296/4359985
