class ChangeOpinionActiveDefault < ActiveRecord::Migration[7.0]
  def change
    change_column :opinions, :active, :boolean, default: true
  end
end
