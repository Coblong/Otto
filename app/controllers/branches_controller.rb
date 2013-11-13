class BranchesController < ApplicationController
  before_action :signed_in_user, :set_branch, only: [:show, :edit, :update, :destroy]

  def new
    @estate_agent = EstateAgent.find(params[:estate_agent_id])
    @branch = @estate_agent.branches.build
  end

  def create
    @estate_agent = EstateAgent.find(params[:estate_agent_id])
    @branch = @estate_agent.branches.build(branch_params)

    if @branch.save
      flash[:success] = "Branch created!"
      redirect_to root_path estate_agent_id: @estate_agent.id, branch_id: @branch.id
    else
      render 'new'
    end
  end

  private

    def set_branch
      @branch = Branch.find(params[:id])
      
      @estate_agents = current_user.estate_agents
      @estate_agent = @branch.estate_agent 
      @branches = @estate_agent.branches
      @agents = @branch.agents
      @properties = @branch.properties
    end

    def branch_params
      params.require(:branch).permit(:name, :comment)
    end
end