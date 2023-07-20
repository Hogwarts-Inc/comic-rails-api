class Canva < ApplicationRecord
  belongs_to :chapter, class_name: 'Chapter', foreign_key: 'chapter_id'
end
