class Status < ActiveRecord::Base
  belongs_to :user
  has_many :properties, dependent: :restrict_with_exception
  validates :user_id, presence: true
  validates :description, presence: true
  default_scope -> { order('id') }  
end
