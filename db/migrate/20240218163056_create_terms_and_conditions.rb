class CreateTermsAndConditions < ActiveRecord::Migration[7.0]
  def change
    create_table :terms_and_conditions do |t|
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
