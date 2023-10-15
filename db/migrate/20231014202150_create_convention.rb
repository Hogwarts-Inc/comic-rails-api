class CreateConvention < ActiveRecord::Migration[7.0]
  def change
    create_table :conventions do |t|
      t.string :name
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
