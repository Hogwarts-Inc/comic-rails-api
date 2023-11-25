class AddUserProfileToCanva < ActiveRecord::Migration[7.0]
  def change
    add_reference :canvas, :user_profile, foreign_key: true
  end
end
