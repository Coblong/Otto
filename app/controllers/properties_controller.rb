class PropertiesController < ApplicationController
  before_action :set_property_in_controller, only: [:show, :edit]  
  skip_before_filter  :verify_authenticity_token

  def show
    puts 'the current property is ' + current_property.address
    puts 'the current branch is ' + current_branch.name
  end

  def create
    puts 'Trying to create or update property with url ' + params[:url].to_s

    @property = Property.find_by(external_ref: params[:url])    
    
    if @property.nil?
      puts 'This is a new property so create it'
      estate_agent_ref = params[:estate_agent].partition(',').first
      @estate_agent = find_or_create_estate_agent(estate_agent_ref)    
      @branch = find_or_create_branch(@estate_agent, params[:branch]);
      
      area_code = params[:post_code].partition('_').first
      post_code = params[:post_code].gsub('_', ' ')
      @area_code = find_or_create_area_code(area_code)
      
      @property = @estate_agent.properties.build
      @property.branch = @branch
      @property.external_ref = params[:url]
      @property.address = params[:address].partition(',').first
      puts 'about to set the area code to ' + @area_code.description
      @property.area_code = @area_code
      puts 'about to set the post code to ' + post_code
      @property.post_code = post_code
      @property.url = params[:hostname]
      @property.asking_price = params[:asking_price]
      @property.status = Status.find(params[:status_id])    
      @property.call_date = Date.today
      
      note = @property.notes.build
      note.content = 'Created'
      note.note_type = Note.TYPE_AUTO      
      puts 'Property notes ' + @property.notes.to_s
    else
      new_status = Status.find(params[:status_id])    
      if new_status.id != @property.status.id
        note = @property.notes.build
        note.content = 'Status changed from ' + @property.status.description + ' to ' + new_status.description
        note.note_type = Note.TYPE_STATUS
        @property.status = new_status      
      end
    end

    if @property.save()      
      puts 'Property saved'
      note.save
      puts 'Note saved'
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
      @property = Property.find_by(external_ref: params[:url]);
      if @property.nil?
        puts 'Property not found'
        response = { "statuses" => current_user.statuses.to_json }
        puts 'the response is ---------------- ' + response.to_s
        render :json => response
      else
        response = build_response
        puts '.............................................'
        puts response.to_s
        puts '.............................................'
        render :json => response
      end
    end
  end

  def create_note
    if !current_user
      render :nothing => true, :status => :unauthorized
    else
      @property = Property.find_by(external_ref: params[:url]);
      if @property.nil?
        puts 'Property not found'
        response = { "statuses" => current_user.statuses.to_json }
        render :json => response
      else      
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

        note = @property.notes.build
        note.content = params[:note]
        note.agent_id = agent.id
        note.branch_id = branch.id
        note.estate_agent_id = branch.estate_agent_id
        note.note_type = Note.TYPE_MANUAL

        note.save()
        
        response = build_response
        puts response.to_s
        render :json => response
      end
    end
  end

  def update_call_date
    puts 'Here we are'
    puts params.to_yaml
    @property = Property.find(params[:property_id])    
    puts 'property is ' + @property.to_yaml
    new_date = params[:new_call_date]
    puts 'new call date is ' + new_date.to_s
    @property.call_date = Date.parse( new_date.gsub(/, */, '-') )
    puts 'the new date is ' + @property.call_date_formatted
    if @property.save()    
      render :json => {call_date: @property.call_date_formatted}, :status => :created
    else
      render :nothing => true, :status => :internal_server_error
    end
  end

  def update
    @property = Property.find(params[:id])    
    @property.update_attributes!(property_params)
    redirect_to @property
  end

  private

    def find_or_create_estate_agent(estate_agent_ref)      
      estate_agent = EstateAgent.find_by(external_ref: estate_agent_ref);
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
      area_code = AreaCode.find_by(user_id: current_user.id, description: area_code_desc);
      if area_code.nil?
        puts 'Creating new area code'
        area_code = current_user.area_codes.create(description: area_code_desc)      
      else
        puts 'Found area code ' + area_code.to_yaml
      end

      return area_code
    end

    def set_property_in_controller
      set_property(Property.find(params[:id]))
    end

    def property_params
      params.require(:property).permit(:address, :post_code, :asking_price, :url, :status, :estate_agent, :branch_id, :agent_id, :call_date)
    end

    def build_response
      { "status_id" => @property.status_id, "statuses" => current_user.statuses.to_json, 
        "estate_agent_name" => @property.estate_agent.name, "branch_name" => @property.branch.name, 
        "agents" => @property.branch.agents.to_json(only: [:id, :name] ),
        "notes" => @property.notes.to_json(only: [:content, :note_type], methods: [:formatted_date, :agent_name] ) }
    end
end
