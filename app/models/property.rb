require 'net/http'
require 'nokogiri'

class Property < ActiveRecord::Base
  belongs_to :status, class_name: "Status", foreign_key: "status_id"
  has_and_belongs_to_many :agents
  belongs_to :branch
  belongs_to :estate_agent
  belongs_to :area_code
  belongs_to :user
  has_many :notes, dependent: :destroy
  has_many :alerts, dependent: :destroy
  validates :address, presence: true, length: { maximum: 100 }
  validates :url, length: { maximum: 200 }
  default_scope -> { order('call_date asc, branch_id asc, status_id asc') }  

  def full_url
    '//' + url
  end

  def full_asking_price
    if sstc or price_qualifier.nil? or price_qualifier.length == 0
      asking_price unless asking_price.nil?
    else
      price_qualifier + ' ' + asking_price unless asking_price.nil?
    end
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

  def update_status(new_status_id, update)
    puts 'Updating status [' + self.status_id.to_s + '] to [' + new_status_id.to_s + ']'    
    if new_status_id.to_i > 0
      new_status = Status.find(new_status_id)
    else
      new_status = self.user.statuses.first
    end
    if new_status != self.status
      if update
        new_status = Status.find(new_status_id)
        note = self.notes.build
        note.content = 'Status changed from ' + self.status.description + ' to ' + new_status.description
        note.note_type = Note.TYPE_STATUS
        note.save      
      end
      self.status = new_status
    end
    note
  end

  def update_sstc(new_sstc, update, robot)
    puts 'Updating sstc [' + self.sstc.to_s + '] to [' + new_sstc.to_s + ']'    
    if new_sstc.to_s != self.sstc.to_s
      if new_sstc.to_s == "true"
        msg = 'Sold STC'
        self.sstc_count = self.sstc_count + 1
      else
        msg = 'No longer Sold STC'
      end
      if update
        note = self.notes.build
        note.content = msg
        note.note_type = Note.TYPE_SSTC
        note.save      
      end
      if robot
        alert = self.alerts.build
        alert.msg = msg
        alert.alert_type = Alert.TYPE_SSTC
        alert.user = self.user
        alert.save
      end
      self.sstc = new_sstc
    end
  end

  def update_asking_price(new_asking_price, update, robot)
    puts 'Updating asking_price [' + self.asking_price.to_s + '] to [' + new_asking_price + ']'    
    if new_asking_price != self.asking_price
      msg = "Asking price changed from '" + self.asking_price.to_s + "' to '" + new_asking_price + "'"
      if update
        note = self.notes.build
        note.content = msg
        note.note_type = Note.TYPE_PRICE
        note.save
      end
      if robot
        alert = self.alerts.build
        alert.msg = msg
        alert.alert_type = Alert.TYPE_PRICE
        alert.user = self.user
        alert.save
      end
      self.asking_price = new_asking_price      
    end
  end

  def update_call_date(new_call_date)
    if new_call_date != self.call_date
      note = self.notes.build
      self.call_date = new_call_date
      note.content = 'Next call on ' + self.call_date_formatted(:long)
      note.note_type = Note.TYPE_MANUAL
      note.save
    end
  end

  def update_view_date(new_view_date, content, hour, min)
    puts 'Updating view date to ' + new_view_date.to_s
    note = self.notes.build
    note.note_type = Note.TYPE_VIEWING
    note.branch_id = self.branch_id
    note.estate_agent_id = self.estate_agent.id
    
    self.call_date = new_view_date
    self.view_date = DateTime.new(self.call_date.year, self.call_date.month, self.call_date.day, hour, min, 0, 0)            
    note.content = 'Viewing on ' + self.view_date.strftime('%A, %d %b %Y at %H:%M')  
    if !content.nil?
      note.content += ' - ' + content 
    end
  
    note.save
    note
  end

  def update_closed_yn(new_closed_yn, update)
    puts 'Updating closed [' + self.closed.to_s + '] to [' + new_closed_yn.to_s + ']'    
    if self.closed.to_s != new_closed_yn.to_s            
      if update
        note = self.notes.build      
        if new_closed_yn.to_s == "true"
          note.content = 'Closed'      
        else
          note.content = "Reopened"
        end
        note.note_type = Note.TYPE_MANUAL
        note.branch_id = self.branch_id
        note.estate_agent_id = self.estate_agent.id
        note.save      
      end
      self.closed = new_closed_yn
    end
    note
  end

  def check_for_updates
    
    #live_url = URI.parse(self.full_url)
    #req = Net::HTTP::Get.new(live_url.path)
    #res = Net::HTTP.start(live_url.host, live_url.port) { |http|
    #  http.request(req)
    #}

    #@doc = Nokogiri::HTML(res.body)

    #puts 'Been closed = ' + @doc.css(".property-header-qualifier").text
    puts 'Robot disabled'
  end
end



