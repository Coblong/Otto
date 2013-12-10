class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit]  
  skip_before_filter  :verify_authenticity_token

  def show
  end

  def create
    puts 'Trying to create or update property with url ' + params[:url].to_s

    @property = Property.find_by(external_ref: params[:url])    
    
    if @property.nil?
      puts 'This is a new property so create it'
      estate_agent_ref = params[:estate_agent].partition(',').first
      @estate_agent = find_or_create_estate_agent(estate_agent_ref)    
      branch_ref = params[:branch].partition(',').first
      @branch = find_or_create_branch(@estate_agent, branch_ref);

      @property = @estate_agent.properties.build
      @property.branch = @branch
      @property.external_ref = params[:url]
      @property.address = params[:address].partition(',').first
      @property.url = params[:hostname]
      @property.asking_price = params[:asking_price]
      @property.status = Status.find(params[:status_id])    

      note = @property.notes.build
      note.content = 'Created'
      note.note_type = 'auto'      
      puts 'Property notes ' + @property.notes.to_s
    else
      new_status = Status.find(params[:status_id])    
      if new_status.id != @property.status.id
        note = @property.notes.build
        note.content = 'Status changed from ' + @property.status.description + ' to ' + new_status.description
        note.note_type = 'status'                
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
        note.note_type = 'manual'

        note.save()
        
        response = build_response
        puts response.to_s
        render :json => response
      end
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

    def set_property
      @property = Property.find(params[:id])      
      @estate_agent = @property.estate_agent
      @branch = @property.branch
      @estate_agents = current_user.estate_agents
      @branches = @estate_agent.branches
      @agents = @estate_agent.agents
      @properties = Property.all
    end

    def property_params
      params.require(:property).permit(:address, :postcode, :asking_price, :url, :status, :estate_agent, :branch_id, :agent_id)
    end

    def build_response
      { "status_id" => @property.status_id, "statuses" => current_user.statuses.to_json, 
        "estate_agent_name" => @property.estate_agent.name, "branch_name" => @property.branch.name, 
        "agents" => @property.branch.agents.to_json(only: [:id, :name] ),
        "notes" => @property.notes.to_json(only: [:content, :note_type], methods: [:formatted_date, :agent_name] ) }
    end
end
