class CreateCharacter < ActiveRecord::Migration[7.0]
  def change
    create_table :characters do |t|
      t.string :name

      t.timestamps
    end
  end
end