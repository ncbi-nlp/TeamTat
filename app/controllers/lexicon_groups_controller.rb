class LexiconGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lexicon_group, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:new, :create, :index, :load_samples]
  before_action :set_top_menu
  helper_method :sort_column, :sort_direction
  semantic_breadcrumb 'Projects', :projects_path

  # GET /lexicon_groups
  # GET /lexicon_groups.json
  def index
    semantic_breadcrumb @project.name, @project
    semantic_breadcrumb "Lexicons", project_lexicon_groups_path(@project)
    @lexicon_groups = @project.lexicon_groups.page params[:page]
  end

  # GET /lexicon_groups/1
  # GET /lexicon_groups/1.json
  def show
  end

  # GET /lexicon_groups/new
  def new
    exit_if_not_manager and return
    @lexicon_group = LexiconGroup.new
  end

  # GET /lexicon_groups/1/edit
  def edit
  end

  def load_samples
    exit_if_not_manager and return
    LexiconGroup.load_samples(@project)
    respond_to do |format|
      format.html { redirect_to project_lexicon_groups_url(@project), notice: 'The lexicon was successfully created.' }
    end
  end

  # POST /lexicon_groups
  # POST /lexicon_groups.json
  def create
    @lexicon_group = @project.lexicon_groups.new(lexicon_group_params)
    exit_if_not_manager and return

    respond_to do |format|
      if @lexicon_group.save
        format.html { redirect_to project_lexicon_groups_path(@project), notice: 'The lexicon was successfully created.' }
        format.json { render :show, status: :created, location: @lexicon_group }
      else
        format.html { render :new }
        format.json { render json: @lexicon_group.errors, status: :unprocessable_entity }
      end
    end
  end

# PATCH/PUT /lexicon_groups/1
  # PATCH/PUT /lexicon_groups/1.json
  def update
    @project = @lexicon_group.project
    exit_if_not_manager and return
    respond_to do |format|
      if @lexicon_group.update(lexicon_group_params)
        format.html { redirect_back fallback_location: project_lexicon_groups_path(@project), notice: 'The lexicon was successfully updated.' }
        format.json { render :show, status: :ok, location: @lexicon_group }
      else
        format.html { render :edit }
        format.json { render json: @lexicon_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lexicon_groups/1
  # DELETE /lexicon_groups/1.json
  def destroy
    @project = @lexicon_group.project
    exit_if_not_manager and return
    @lexicon_group.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: project_lexicon_groups_path(@project), notice: 'The lexicon was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lexicon_group
      @lexicon_group = LexiconGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lexicon_group_params
      params.require(:lexicon_group).permit(:name, :user_id)
    end

    def set_project
      @project = Project.find(params[:project_id])
      exit_if_not_member and return false
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
