class CreateGraphicResources < ActiveRecord::Migration[7.0]
  def change
    create_table :graphic_resources do |t|
      t.integer :resource_type, default: 0

      t.timestamps
    end
  end
end
