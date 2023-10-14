class CreateDescription < ActiveRecord::Migration[7.0]
  def change
    create_table :descriptions do |t|
      t.string :title
      t.string :text
      t.boolean :active, default: false
      t.references :descriptionable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
