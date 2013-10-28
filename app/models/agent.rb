class Agent < ActiveRecord::Base
  belongs_to :estate_agent
  default_scope -> { order('created_at DESC') }
  validates :estate_agent_id, presence: true
  validates :name, presence: true, length: { maximum: 100 }
  validates :comment, length: { maximum: 200 }
end
