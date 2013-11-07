class Property < ActiveRecord::Base
  belongs_to :agent
  belongs_to :branch
  belongs_to :estate_agent
  validates :agent_id, presence: true
  validates :branch_id, presence: true
  validates :estate_agent_id, presence: true
  validates :address, presence: true, length: { maximum: 100 }
  validates :url, length: { maximum: 200 }
  default_scope -> { order('created_at DESC') }  
end
