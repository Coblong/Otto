class Agent < ActiveRecord::Base
  belongs_to :branch
  belongs_to :estate_agent
  validates :branch_id, presence: true
  validates :estate_agent_id, presence: true
  validates :name, presence: true, length: { maximum: 100 }
  validates :comment, length: { maximum: 200 }
  default_scope -> { order('created_at DESC') }
end
