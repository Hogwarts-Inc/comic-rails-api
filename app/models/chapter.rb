class Chapter < ApplicationRecord
  belongs_to :storiette, class_name: 'Storiette', foreign_key: 'storiette_id'

  has_many :canvas, dependent: :destroy
end
