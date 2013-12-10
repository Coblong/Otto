class Property < ActiveRecord::Base
  belongs_to :status  
  has_and_belongs_to_many :agents
  belongs_to :branch
  belongs_to :estate_agent
  has_many :notes, dependent: :destroy
  validates :address, presence: true, length: { maximum: 100 }
  validates :url, length: { maximum: 200 }
  default_scope -> { order('created_at DESC') }  

  def full_url
    puts 'the full url for this property is http://' + url + external_ref
    'http://' + url + external_ref
  end

  def statuses
    Status.all
  end
end
