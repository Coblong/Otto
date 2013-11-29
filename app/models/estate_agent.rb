class EstateAgent < ActiveRecord::Base
  belongs_to :user
  has_many :branches, dependent: :destroy
  has_many :agents, :through => :branches
  has_and_belongs_to_many :properties
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 100 }
  validates :comment, length: { maximum: 200 }
end
