class AreaCode < ActiveRecord::Base
  belongs_to :user
  has_many :properties, dependent: :destroy
  validates :user_id, presence: true
  validates :description, presence: true, length: { maximum: 4 }
end
