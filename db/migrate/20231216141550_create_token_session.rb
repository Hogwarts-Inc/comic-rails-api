class CreateTokenSession < ActiveRecord::Migration[7.0]
  def change
    create_table :token_sessions do |t|
      t.string :token
      t.references :user_profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
