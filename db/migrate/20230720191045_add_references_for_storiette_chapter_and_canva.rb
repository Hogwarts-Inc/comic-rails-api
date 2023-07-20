class AddReferencesForStorietteChapterAndCanva < ActiveRecord::Migration[7.0]
  def change
    add_reference :canvas, :chapter, null: true, foreign_key: true
    add_reference :chapters, :storiette, null: true, foreign_key: true
  end
end
