class Status < ActiveRecord::Base
  belongs_to :user
  has_many :properties
  validates :user_id, presence: true
  validates :description, presence: true
  default_scope -> { order('id') }  
end
