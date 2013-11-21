class Property < ActiveRecord::Base
  has_many :agents
  has_many :branches
  has_many :estate_agents
  validates :address, presence: true, length: { maximum: 100 }
  validates :url, length: { maximum: 200 }
  default_scope -> { order('created_at DESC') }  
end
