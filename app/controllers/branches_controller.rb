class BranchesController < ApplicationController
  before_action :signed_in_user, :set_branch_in_controller, only: [:new, :show, :edit, :update, :destroy]

  def index
    puts 'Getting branches'
    if params[:estate_agent_id].nil?
      branches = Branch.where("estate_agent_id in (?)", current_user.estate_agents.collect(&:id))  
    else
      branches = Branch.where(estate_agent_id: params[:estate_agent_id])  
    end

    response = { "branches" => branches.to_json(only: [:id, :name] ) }
    render json: response
  end

  def new
    @estate_agents = current_user.estate_agents
    @estate_agent = EstateAgent.find(params[:estate_agent_id])
    @branch = @estate_agent.branches.build
    @properties = @branch.properties
  end

  def show
  end

  def edit
  end

  def create
    @estate_agent = EstateAgent.find(params[:branch][:estate_agent_id])
    @branch = @estate_agent.branches.build(branch_params)

    if @branch.save
      flash[:success] = "Branch created!"
      redirect_to root_path estate_agent_id: @estate_agent.id, branch_id: @branch.id
    else
      render 'new'
    end
  end

  def update
    branch = current_branch
    branch.name = params[:branch][:name]
    branch.comment = params[:branch][:comment]
    if branch.save
      render 'show'
    end
  end
  
  private

    def set_branch_in_controller
      set_branch(Branch.find(params[:id]))
    end

    def branch_params
      params.require(:branch).permit(:name, :comment)
    end
end
