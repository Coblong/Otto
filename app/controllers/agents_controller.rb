class AgentsController < ApplicationController
  before_action :signed_in_user, :set_agent_in_controller, only: [:show, :edit, :update, :destroy]

  def index
    puts 'Getting agents'
    puts params.to_yaml
    if params[:branch_id].nil?
      agents = Agent.where("branch_id in (?)", Branch.where("estate_agent_id in (?)", current_user.estate_agents.collect(&:id)).collect(&:id))  
    else
      agents = Agent.where(branch_id: params[:branch_id])  
    end

    response = { "agents" => agents.to_json(only: [:id, :name] ) }
    render json: response
  end

  def show
    puts 'inside the agent controller show method'
  end
  
  def new
    @estate_agents = current_user.estate_agents
    @branch = Branch.find(params[:branch_id])
    @estate_agent = @branch.estate_agent
    @branches = @estate_agent.branches
    @agent = @branch.agents.build
    @properties = @branch.properties
  end

  def edit
    @agent = Agent.find(params[:id])
  end

  def update
    agent = current_agent
    agent.name = params[:agent][:name]
    agent.comment = params[:agent][:comment]
    if agent.save!
      render 'show'
    end
  end

  def create
    @branch = Branch.find(params[:agent][:branch_id])
    @agent = @branch.agents.build(agent_params)
    @agent.estate_agent = @branch.estate_agent
    if @agent.save
      flash[:success] = "Agent created!"
      redirect_to root_path estate_agent_id: @branch.estate_agent.id, branch_id: @branch.id, agent_id: @agent.id
    else
      redirect_to "new"
    end
  end

  private

    def set_agent_in_controller
      set_agent(Agent.find(params[:id]))
    end

    def agent_params
      params.require(:agent).permit(:name, :comment, :estate_agent)
    end

end
