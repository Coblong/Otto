class EstateAgent < ActiveRecord::Base
  belongs_to :user
  has_many :branches, dependent: :destroy
  has_many :agents, :through => :branches
  has_many :properties, dependent: :destroy
  has_many :notes, dependent: :destroy
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 100 }
  validates :comment, length: { maximum: 500 }
end
