class Alert < ActiveRecord::Base
  belongs_to :user
  belongs_to :property
  validates :msg, length: { maximum: 200 }
  default_scope -> { order('created_at DESC') }

  @TYPE_MANUAL = "manual"
  @TYPE_SSTC = "sstc"
  @TYPE_PRICE = "price"
  @TYPE_LSITED = "listed"
  
  class << self
    attr_accessor :TYPE_MANUAL, :TYPE_SSTC, :TYPE_PRICE, :TYPE_LISTED
  end

  def formatted_date 
    created_at.to_formatted_s(:short)
  end

end
