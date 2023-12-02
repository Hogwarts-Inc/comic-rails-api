class CreateLike < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :canva, null: false, foreign_key: true
      t.references :user_profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
