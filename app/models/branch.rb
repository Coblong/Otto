class Branch < ActiveRecord::Base
  belongs_to :estate_agent
  has_many :agents, dependent: :destroy
  has_and_belongs_to_many :properties
  validates :estate_agent_id, presence: true
  validates :name, presence: true, length: { maximum: 100 }
  validates :comment, length: { maximum: 200 }
  default_scope -> { order('created_at DESC') }
end
