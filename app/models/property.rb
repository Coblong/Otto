class Property < ActiveRecord::Base
  belongs_to :status, class_name: "Status", foreign_key: "status_id"
  has_and_belongs_to_many :agents
  belongs_to :branch
  belongs_to :estate_agent
  belongs_to :area_code
  belongs_to :user
  has_many :notes, dependent: :destroy
  validates :address, presence: true, length: { maximum: 100 }
  validates :url, length: { maximum: 200 }
  default_scope -> { order('call_date asc, branch_id asc, status_id asc') }  

  def full_url
    '//' + url + external_ref
  end

  def statuses
    Status.all
  end

  def call_date_formatted(text)
    if text == :short
      if self.call_date == Date.today
        'Today'
      elsif self.call_date == Date.tomorrow
        'Tomorrow'
      else
        self.call_date.strftime('%A, %d %b') unless self.call_date.nil?
      end
    else
      self.call_date.strftime('%A, %d %b %Y') unless self.call_date.nil?
    end
  end

  def view_date_formatted
    self.view_date.strftime('%A, %d %b %H:%M') unless self.view_date.nil?
  end

  def viewing_soon?
    if !self.view_date.nil?
      self.view_date > Date.today
    end
  end

  def check_for_updates
    puts 'Robot checking for updates'
    puts '  ' + self.address
    puts '  ' + self.asking_price
    puts '  ' + self.sstc.to_s
    puts '--------------------------------------------------'
  end
end
