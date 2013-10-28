class SausagesController < ApplicationController
  before_action :set_sausage, only: [:show, :edit, :update, :destroy]

  # GET /sausages
  # GET /sausages.json
  def index
    @sausages = Sausage.all
  end

  # GET /sausages/1
  # GET /sausages/1.json
  def show
  end

  # GET /sausages/new
  def new
    @sausage = Sausage.new
  end

  # GET /sausages/1/edit
  def edit
  end

  # POST /sausages
  # POST /sausages.json
  def create
    @sausage = Sausage.new(sausage_params)

    respond_to do |format|
      if @sausage.save
        format.html { redirect_to @sausage, notice: 'Sausage was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sausage }
      else
        format.html { render action: 'new' }
        format.json { render json: @sausage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sausages/1
  # PATCH/PUT /sausages/1.json
  def update
    respond_to do |format|
      if @sausage.update(sausage_params)
        format.html { redirect_to @sausage, notice: 'Sausage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sausage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sausages/1
  # DELETE /sausages/1.json
  def destroy
    @sausage.destroy
    respond_to do |format|
      format.html { redirect_to sausages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sausage
      @sausage = Sausage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sausage_params
      params[:sausage]
    end
end
