class Note < ActiveRecord::Base
  belongs_to :property
  belongs_to :agent
  belongs_to :branch
  belongs_to :estate_agent
  validates :content, length: { maximum: 500 }
  default_scope -> { order('created_at DESC') }

  @TYPE_MANUAL = "manual"
  @TYPE_LISTED = "listed"
  @TYPE_STATUS = "status"
  @TYPE_SSTC = "sstc"
  @TYPE_PRICE = "price"
  @TYPE_AUTO = "auto"
  @TYPE_VIEWING = "viewing"
  @TYPE_OFFER = "offer"
  
  class << self
    attr_accessor :TYPE_MANUAL, :TYPE_LISTED, :TYPE_STATUS, :TYPE_SSTC, :TYPE_PRICE, :TYPE_AUTO, :TYPE_VIEWING, :TYPE_OFFER 
  end

  def formatted_date 
    created_at.to_formatted_s(:short)
  end

  def agent_name
    self.agent.name unless self.agent.nil?
  end
end
