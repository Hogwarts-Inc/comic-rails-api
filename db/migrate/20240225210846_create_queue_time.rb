class CreateQueueTime < ActiveRecord::Migration[7.0]
  def change
    create_table :queue_times do |t|
      t.integer :remove_from_queue_time
      t.boolean :active, default: false

      t.timestamps
    end
  end
end
