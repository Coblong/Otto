class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit]  
  skip_before_filter  :verify_authenticity_token

  def show
  end

  def create
    puts 'Trying to create new property with url ' + params[:url].to_s

    estate_agent_name = params[:estate_agent].partition(',').first
    @estate_agent = find_or_create_estate_agent(estate_agent_name)    
    branch_name = params[:branch].partition(',').first
    @branch = find_or_create_branch(@estate_agent, branch_name);

    @property = Property.new
    @property.estate_agents << @estate_agent
    @property.branches << @branch
    @property.external_id = params[:url]
    @property.address = params[:address].partition(',').first
    @property.url = params[:hostname]
    @property.postcode = params[:address]
    @property.asking_price = '£100,000'
    @property.status = 'New'

    puts @property.to_yaml

    if @property.save()
      puts 'Property saved'
      render :json => @property
    else
      puts 'Property not saved'
      render :nothing => true, :status => :service_unavailable
    end
  end

  def external
    puts 'Trying to find property for url ' + params[:url].to_s
    @property = Property.find_by(external_id: params[:url]);
    if @property.nil?
      puts 'Property not found'
      render :nothing => true, :status => :service_unavailable
    else
      puts 'Returning property ' + @property.to_yaml
      render :json => @property
    end
  end

  def update
    @property = Property.find(params[:id])
    @property.update_attributes!(property_params)
    redirect_to @property
  end

  private

    def find_or_create_estate_agent(estate_agent_name)      
      estate_agent = EstateAgent.find_by(name: estate_agent_name);
      if estate_agent.nil?
        puts 'Creating new estate agent'
        estate_agent = current_user.estate_agents.create(name: estate_agent_name)      
      else 
        puts 'Found estate agent ' + estate_agent.name
      end
      return estate_agent
    end

    def find_or_create_branch(estate_agent, branch_name)
      estate_agent.branches.each do |branch|
        if branch_name == branch.name
          puts 'Found branch ' + branch.name
          return branch
        end
      end
      puts 'Creating new branch'
      branch = estate_agent.branches.create(name: branch_name);
      return branch
    end

    def set_property
      @property = Property.find(params[:id])      
      @estate_agent = @property.estate_agents.first
      @estate_agents = current_user.estate_agents
      @branches = Array.new
      @agents = Array.new
      @properties = Property.all
    end

    def property_params
      params.require(:property).permit(:address, :postcode, :asking_price, :url, :status, :estate_agent, :branch_id, :agent_id)
    end
end
