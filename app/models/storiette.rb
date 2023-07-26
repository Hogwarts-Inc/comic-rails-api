# frozen_string_literal: true

class Storiette < ApplicationRecord
  has_many :chapters, dependent: :destroy
end
