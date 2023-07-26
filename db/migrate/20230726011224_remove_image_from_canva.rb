class RemoveImageFromCanva < ActiveRecord::Migration[7.0]
  def change
    remove_column :canvas, :image
  end
end
