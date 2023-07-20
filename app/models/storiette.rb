class Storiette < ApplicationRecord
  has_many :chapters, dependent: :destroy
end
