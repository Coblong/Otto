class PropertiesController < ApplicationController
  before_action :set_property, only: [:show, :edit]

  def show
  end

  def update
    @property = Property.find(params[:id])
    @property.update_attributes!(property_params)
    redirect_to @property
  end

  private

    def set_property
      @property = Property.find(params[:id])      
      @estate_agent = @property.estate_agent
      @estate_agents = current_user.estate_agents
      @branches = Array.new
      @agents = Array.new
      @properties = Property.all
    end

    def property_params
      params.require(:property).permit(:address, :postcode, :asking_price, :url, :status, :estate_agent, :branch_id, :agent_id)
    end
end
