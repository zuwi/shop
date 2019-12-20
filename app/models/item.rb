class Item < ApplicationRecord
  belongs_to :brand
  belongs_to :user

  validates :name, presence: true
end
