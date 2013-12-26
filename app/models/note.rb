class Note < ActiveRecord::Base
  belongs_to :property
  belongs_to :agent
  belongs_to :branch
  belongs_to :estate_agent
  validates :content, length: { maximum: 200 }
  default_scope -> { order('created_at DESC') }

  @TYPE_MANUAL = "manual"
  @TYPE_STATUS = "status"
  @TYPE_AUTO = "auto"
  @TYPE_ACTION = "action"

  class << self
    attr_accessor :TYPE_MANUAL, :TYPE_STATUS, :TYPE_AUTO, :TYPE_ACTION 
  end

  def formatted_date 
    created_at.to_formatted_s(:short)
  end

  def agent_name
    if !self.agent.nil?
      return self.agent.name
    end
    ""
  end
end
