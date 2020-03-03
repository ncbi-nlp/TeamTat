class ModelsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_model, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:new, :create, :index, :load_samples]
  before_action :set_top_menu
  helper_method :sort_column, :sort_direction
  semantic_breadcrumb 'Projects', :projects_path

  # GET /models
  # GET /models.json
  def index
    semantic_breadcrumb @project.name, @project
    semantic_breadcrumb "Models", project_models_path(@project)
    @models = @project.models.page params[:page]
  end

  # GET /models/1
  # GET /models/1.json
  def show
    @project = @model.project
  end

  # GET /models/new
  def new
    @model = Model.new
  end

  # GET /models/1/edit
  def edit
  end

  # POST /models
  # POST /models.json
  def create
    @model = @project.models.new(model_params)

    respond_to do |format|
      if @model.save
        format.html { redirect_to @model, notice: 'The model was successfully created.' }
        format.json { render :show, status: :created, location: @model }
      else
        format.html { render :new }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /models/1
  # PATCH/PUT /models/1.json
  def update
    @project = @model.project
    respond_to do |format|
      if @model.update(model_params)
        format.html { redirect_to @model, notice: 'The model was successfully updated.' }
        format.json { render :show, status: :ok, location: @model }
      else
        format.html { render :edit }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /models/1
  # DELETE /models/1.json
  def destroy
    @project = @model.project
    @model.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: project_models_url(@project), notice: 'The model was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      @model = Model.find(params[:id])
    end
    def set_project
      @project = Project.find(params[:project_id])
      unless @project.manager?(current_user)
        respond_to do |format|
          format.html { redirect_back fallback_location: projects_path, alert: "Cannot access models settings"}
          format.json { render json: {msg: 'Cannot accmember settings'}, status: 401 }
        end    
        return false
      end
    end
    def set_top_menu
      @top_menu = 'projects'
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def sort_column
      %w(name email role).include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
