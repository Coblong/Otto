class EstateAgent < ActiveRecord::Base
  has_many :agents, dependent: :destroy
  validates :name, presence: true, length: { maximum: 100 }
  validates :comment, length: { maximum: 200 }
end
