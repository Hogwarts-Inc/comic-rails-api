class AddActiveToModels < ActiveRecord::Migration[7.0]
  def change
    add_column :characters, :active, :boolean, default: true
    add_column :storiettes, :active, :boolean, default: false
    add_column :canvas, :active, :boolean, default: false
    add_column :chapters, :active, :boolean, default: false
  end
end
