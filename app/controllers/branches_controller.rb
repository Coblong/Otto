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
      redirect_to @branch.estate_agent
    else
      render 'new'
    end
  end

  private

    def set_branch
      @branch = Branch.find(params[:id])
    end

    def branch_params
      params.require(:branch).permit(:name, :comment)
    end
end
