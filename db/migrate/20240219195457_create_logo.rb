class CreateLogo < ActiveRecord::Migration[7.0]
  def change
    create_table :logos do |t|
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
