class Property < ActiveRecord::Base
  has_and_belongs_to_many :agents
  has_and_belongs_to_many :branches
  has_and_belongs_to_many :estate_agents
  validates :address, presence: true, length: { maximum: 100 }
  validates :url, length: { maximum: 200 }
  default_scope -> { order('created_at DESC') }  

  def full_url
    puts 'the full url for this property is http://' + url + external_ref
    'http://' + url + external_ref
  end
end
