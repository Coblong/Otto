class PropertiesController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :set_property_in_controller, only: [:show, :edit]  
  skip_before_filter  :verify_authenticity_token

  def show
  end

  def create
    puts 'Trying to create or update property with url ' + params[:url].to_s

    @property = current_user.properties.find_by(external_ref: params[:url])        
    update = true

    if @property.nil?
      puts 'This is a new property so create it'
      
      estate_agent_ref = params[:estate_agent].partition(',').first
      estate_agent = find_or_create_estate_agent(estate_agent_ref)    
      branch = find_or_create_branch(estate_agent, params[:branch]);
      
      area_code = params[:post_code].partition('_').first
      post_code = params[:post_code].gsub('_', ' ')
      area_code = find_or_create_area_code(area_code)
      
      @property = current_user.properties.build
      @property.estate_agent = estate_agent
      @property.branch = branch
      @property.external_ref = params[:url]
      @property.address = params[:address].partition(',').first
      @property.area_code = area_code
      @property.post_code = post_code
      @property.url = params[:hostname]
      @property.call_date = Date.today      
      
      note = @property.notes.build      
      note.note_type = Note.TYPE_AUTO
      note.content = 'Created'
      update = false
    end

    @property.image_url = params[:image_url]
    @property.update_status(params[:status_id], update)
    @property.update_sstc(params[:sstc], update, false)
    @property.update_asking_price(params[:asking_price], update, false)
    @property.update_closed_yn(params[:closed], update)      
    
    if @property.save()      
      puts 'Property saved'
      response = build_response
      puts response.to_s
      render :json => response
    else
      puts 'Property not saved'
      render :nothing => true, :status => :service_unavailable
    end
  end
  
  def external
    if !current_user
      render :nothing => true, :status => :unauthorized
    else
      @property = current_user.properties.find_by(external_ref: params[:url]);
      if @property.nil?
        response = { "statuses" => current_user.statuses.to_json }
        puts response
        render :json => response
      else
        response = build_response
        puts response        
        render :json => response
      end
    end
  end

  def create_note
    if !current_user
      render :nothing => true, :status => :unauthorized
    else
      puts 'Creating new note'
      if !params[:url].nil?
        @property = current_user.properties.find_by(external_ref: params[:url]);
      else
        @property = current_user.properties.find(params[:property_id]);
      end
      if @property.nil?
        response = { "statuses" => current_user.statuses.to_json }
        render :json => response
      else      
        old_call_date = @property.call_date

        / Build the note /
        note = @property.notes.build
        note.note_type = Note.TYPE_MANUAL
        note.content = params[:note]
        note.branch_id = @property.branch_id
        note.estate_agent_id = @property.estate_agent.id

        agent_name = params[:agent]
        branch = Branch.find(@property.branch_id)
        agent = branch.agents.find {|a| a.name == agent_name }
        if agent.nil?
          agent = @property.agents.build
          agent.name = agent_name
          agent.branch_id = @property.branch.id
          agent.estate_agent_id = @property.estate_agent.id
          agent.properties << @property
          agent.save()          
        else
          / Check to see if this property is already linked to this agent /
          if !agent.properties.include? @property
            agent.properties << @property
            agent.save()
          end
        end
        
        note.agent_id = agent.id
        
        if !params[:call_date].nil?            
          @property.call_date = params[:call_date]
          @property.save()
          if note.content.empty?
            note.content = 'Next call on ' + @property.call_date_formatted(:long)
          else
            new_content = 'Next call on ' + @property.call_date_formatted(:long) + ' - ' + note.content
            note.content = new_content
          end            
        end          
        
        note.save()

        date_changed = old_call_date.strftime('%j') != @property.call_date.strftime('%j')
        render :json => note.to_json(methods: [:formatted_date, :agent_name] ), :status => (date_changed ? :accepted : :ok)
      end
    end
  end

  def create_viewing
    puts 'Creating a new viewing'
    if !current_user
      render :nothing => true, :status => :unauthorized
    else
      @property = current_user.properties.find(params[:property_id]);
      if @property.nil?
        response = { "statuses" => current_user.statuses.to_json }
        render :json => response
      else      
        old_call_date = @property.call_date
        note = @property.update_view_date(params[:view_date], params[:note], params[:hours].to_i, params[:mins].to_i)
        @property.save()
        date_changed = old_call_date.strftime('%j') != @property.call_date.strftime('%j')
        render :json => note.to_json(methods: [:formatted_date, :agent_name] ), :status => (date_changed ? :accepted : :ok)
      end
    end
  end

  def create_offer
    puts 'Creating a new offer'
    if !current_user
      render :nothing => true, :status => :unauthorized
    else
      @property = current_user.properties.find(params[:property_id]);
      if @property.nil?
        response = { "statuses" => current_user.statuses.to_json }
        render :json => response
      else      
        offer = params[:offer]
        offer.sub! 'k', '000'
        offer.sub! 'K', '000'
        additional_note = params[:note]
        
        / Build the note /
        note = @property.notes.build
        note.note_type = Note.TYPE_OFFER
        note.content = "Made an offer of " + number_to_currency(offer.to_i, unit: "£")
        if additional_note.length > 0
          note.content += " - " + additional_note 
        end
        note.branch_id = @property.branch_id
        note.estate_agent_id = @property.estate_agent.id

        note.save()

        render :json => note.to_json(methods: [:formatted_date, :agent_name] ), :status => :ok
      end
    end
  end

  def close
    puts 'Close property'
    if !current_user
      render :nothing => true, :status => :unauthorized
    else
      @property = current_user.properties.find(params[:property_id]);
      if @property.nil?
        response = { "statuses" => current_user.statuses.to_json }
        render :json => response
      else      

        note = @property.update_closed_yn(true, true)      
        @property.save()

        render :json => note.to_json(methods: [:formatted_date, :agent_name] ), :status => :ok
      end
    end
  end

  def reopen
    puts 'Reopen property'
    if !current_user
      render :nothing => true, :status => :unauthorized
    else
      @property = current_user.properties.find(params[:property_id]);
      if @property.nil?
        response = { "statuses" => current_user.statuses.to_json }
        render :json => response
      else      

        note = @property.update_closed_yn(false, true)      
        @property.save()
        
        render :json => note.to_json(methods: [:formatted_date, :agent_name] ), :status => :ok
      end
    end
  end

  def delete_note
    note = Note.find(params[:note_id])
    @property = note.property
    puts 'deleting note for property - ' + @property.to_yaml
    if note.delete
      puts 'Note deleted'
        response = build_response
        puts response.to_s
        render :json => response
    else
      puts 'Note not deleted'
      render :nothing => true, :status => :service_unavailable
    end
  end

  def update_call_date
    property = current_user.properties.find(params[:property_id])    
    new_date = params[:new_call_date]    
    property.call_date = Date.parse( new_date.gsub(/, */, '-') )    
    property.update_call_date(new_date)
    if property.save()    
      render :json => {call_date: property.call_date_formatted(:short)}, :status => :created
    else
      render :nothing => true, :status => :internal_server_error
    end
  end

  def update_status
    property = current_user.properties.find(params[:property_id])    
    note = property.update_status(params[:new_status], true)
    if property.save()    
      render :json => {new_status_colour: property.status.colour, note: note.to_json(methods: [:formatted_date, :agent_name] )}, :status => :created
    else
      render :nothing => true, :status => :internal_server_error
    end
  end

  def edit
    @estate_agents = current_user.estate_agents
  end

  def update
    puts 'Updating property'
    @property = current_user.properties.find(params[:id])    
    @property.update_attributes!(property_params)
    redirect_to @property
  end

  private

    def find_or_create_estate_agent(estate_agent_ref)      
      estate_agent = current_user.estate_agents.find_by(external_ref: estate_agent_ref);
      if estate_agent.nil?
        puts 'Creating new estate agent'
        estate_agent = current_user.estate_agents.create(name: estate_agent_ref, external_ref: estate_agent_ref)      
      else 
        puts 'Found estate agent ' + estate_agent.name
      end
      return estate_agent
    end

    def find_or_create_branch(estate_agent, branch_ref)

      branch_elements = params[:branch].split(',')
      if branch_elements.size > 1
        branch_ref = branch_elements.second.gsub(/\s+/, "")
      else
        branch_ref = branch_elements.first.gsub(/\s+/, "")
      end

      estate_agent.branches.each do |branch|
        if branch_ref == branch.external_ref
          puts 'Found branch ' + branch.name
          return branch
        end
      end
      puts 'Creating new branch'
      branch = estate_agent.branches.create(name: branch_ref, external_ref: branch_ref);
      return branch
    end

    def find_or_create_area_code(area_code_desc)      
      area_code = current_user.area_codes.find_by(user_id: current_user.id, description: area_code_desc);
      if area_code.nil?
        puts 'Creating new area code'
        area_code = current_user.area_codes.create(description: area_code_desc)      
      else
        puts 'Found area code ' + area_code.to_yaml
      end

      return area_code
    end

    def set_property_in_controller
      set_property(current_user.properties.find(params[:id]))
    end

    def property_params
      params.require(:property).permit(:address, :post_code, :asking_price, :url, :status, :sstc, :estate_agent, :branch_id, :agent_id, :call_date)
    end

    def build_response
      { "id" => @property.id, "status_id" => @property.status_id, "closed" => @property.closed, "sstc" => @property.sstc, "asking_price" => @property.asking_price, "statuses" => current_user.statuses.to_json, 
        "estate_agent_name" => @property.estate_agent.name, "branch_name" => @property.branch.name, 
        "agents" => @property.branch.agents.to_json(only: [:id, :name] ),
        "notes" => @property.notes.to_json(only: [:content, :note_type], methods: [:formatted_date, :agent_name] ) }
    end
end
