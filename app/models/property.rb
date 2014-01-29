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
  default_scope -> { order('call_date asc, branch_id asc, status_id asc, address asc') }  

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

  def view_date_formatted(text)
    if text == :long
      if self.view_date.nil?
        Date.today.strftime('%A, %d %b %Y')
      else
        self.call_date.strftime('%A, %d %b %Y')
      end
    else
      self.view_date.strftime('%A, %d %b %H:%M') unless self.view_date.nil?
    end
  end

  def viewing_soon?
    if !self.view_date.nil?
      self.view_date > Date.today
    end
  end

  def update_status(new_status_id, update)
    puts 'Updating status from [' + self.status_id.to_s + '] to [' + new_status_id.to_s + ']'    
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

  def update_important_attributes(new_sstc, new_asking_price, new_price_qualifier, new_listed, add_alert)
    puts 'Updating important attributes'
    puts 'SSTC from [' + self.sstc.to_s + '] to [' + new_sstc.to_s + ']'
    puts 'Asking price from [' + self.asking_price.to_s + '] to [' + new_asking_price.to_s + ']'
    puts 'Price qualifier from [' + self.price_qualifier.to_s + '] to [' + new_price_qualifier + ']'
    puts 'Listed from [' + self.listed.to_s + '] to [' + new_listed.to_s + ']'
    if !new_listed.nil? and new_listed.to_s == "false"      
      msg = 'No longer listed'
      add_note(msg, Note.TYPE_LISTED)
      add_alert(msg, Alert.TYPE_LISTED) if add_alert
    else
      if self.sstc.nil? and new_sstc.to_s == "true"
        self.sstc_count = 1
      end
      if !self.sstc.nil? and self.sstc.to_s != new_sstc
        # SSTC changed so changed that and leave everything else
        if new_sstc
          msg = 'Sold STC'
          self.sstc_count = self.sstc_count + 1
        else
          msg = new_sstc = 'No longer Sold STC' 
        end
        add_note(msg, Note.TYPE_SSTC)
        add_alert(msg, Alert.TYPE_SSTC) if add_alert
      else
        if !self.asking_price.nil? and self.asking_price != new_asking_price
          msg = "Price changed from '" + self.asking_price + "' to '" + new_asking_price + "'"
          add_note(msg, Note.TYPE_PRICE)
          add_alert(msg, Alert.TYPE_PRICE) if add_alert
        end
      end
    end
    update_attributes(sstc: new_sstc, asking_price: new_asking_price, price_qualifier: new_price_qualifier, listed: new_listed)
  end

  def add_note(msg, note_type)
    note = self.notes.build
    note.content = msg
    note.note_type = note_type
    note.branch_id = self.branch_id
    note.estate_agent_id = self.estate_agent.id
    note.save 
    note     
  end

  def add_alert(msg, alert_type)
    alert = self.alerts.build
    alert.msg = msg
    alert.alert_type = alert_type
    alert.user = self.user
    alert.save
    alert
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
    if !content.nil? and content.length > 0
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

end



