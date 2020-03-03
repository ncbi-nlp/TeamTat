class LexiconsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lexicon, only: [:show, :edit, :update, :destroy]
  before_action :set_lexicon_group, only: [:new, :create, :index, :upload]
  before_action :set_top_menu

  # GET /lexicons
  # GET /lexicons.json
  def index
    breadcrumb_for_projects(@project)
    semantic_breadcrumb @project.name, @project
    semantic_breadcrumb "Lexicons", project_lexicon_groups_path(@project)
    semantic_breadcrumb @lexicon_group.name, lexicon_group_lexicons_path(@lexicon_group)
    @lexicons = @lexicon_group.lexicons.page params[:page]
    respond_to do |format|
      format.html
      format.csv { send_data Lexicon.to_csv(@lexicons), filename: "lexicon_#{@lexicon_group.id}_#{Time.now.strftime("%Y%m%d%H%M%S")}.tsv" }
    end
  end

  # GET /lexicons/1
  # GET /lexicons/1.json
  def show
    @lexicon_group = @lexicon.lexicon_group
    breadcrumb_for_projects(@project)
    semantic_breadcrumb @project.name, @project

    semantic_breadcrumb "Lexicons", project_lexicon_groups_path(@project)
    semantic_breadcrumb @lexicon_group.name, lexicon_group_lexicons_path(@lexicon_group)
    semantic_breadcrumb @lexicon.lexicon_id
  end

  # GET /lexicons/new
  def new
    breadcrumb_for_projects(@project)
    semantic_breadcrumb @project.name, @project

    semantic_breadcrumb "Lexicons", project_lexicon_groups_path(@project)
    semantic_breadcrumb @lexicon_group.name, lexicon_group_lexicons_path(@lexicon_group)
    semantic_breadcrumb "new"
    @lexicon = @lexicon_group.lexicons.new
    exit_if_not_manager and return
  end

  # GET /lexicons/1/edit
  def edit
    @lexicon_group = @lexicon.lexicon_group
    breadcrumb_for_projects(@project)
    semantic_breadcrumb @project.name, @project

    semantic_breadcrumb "Lexicons", project_lexicon_groups_path(@project)
    semantic_breadcrumb @lexicon_group.name, lexicon_group_lexicons_path(@lexicon_group)
    semantic_breadcrumb "edit"
    exit_if_not_manager and return
  end

  def upload
    breadcrumb_for_projects(@project)
    semantic_breadcrumb @project.name, @project

    semantic_breadcrumb "Lexicons", project_lexicon_groups_path(@project)
    semantic_breadcrumb @lexicon_group.name, lexicon_group_lexicons_path(@lexicon_group)
    semantic_breadcrumb "edit"
    exit_if_not_manager and return

    respond_to do |format|
      if @lexicon_group.upload_lexicon(params[:file])
        format.html { redirect_back fallback_location: lexicon_group_lexicons_path(@lexicon_group), notice: 'The lexicon was successfully uploaded.' }
      else
        format.html { redirect_back fallback_location: lexicon_group_lexicons_path(@lexicon_group), error: "Error."}
      end
    end
  end

  # POST /lexicons
  # POST /lexicons.json
  def create
    breadcrumb_for_projects(@project)
    semantic_breadcrumb @project.name, @project

    semantic_breadcrumb "Lexicons", project_lexicon_groups_path(@project)
    semantic_breadcrumb @lexicon_group.name, lexicon_group_lexicons_path(@lexicon_group)
    semantic_breadcrumb "new"
    exit_if_not_manager and return

    @lexicon = @lexicon_group.lexicons.new(lexicon_params)
    respond_to do |format|
      if @lexicon.save
        format.html { redirect_back fallback_location: lexicon_group_lexicons_path(@lexicon_group), notice: 'The concept was successfully created.' }
        format.json { render :show, status: :created, location: @lexicon }
      else
        format.html { render :new }
        format.json { render json: @lexicon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lexicons/1
  # PATCH/PUT /lexicons/1.json
  def update
    @lexicon_group = @lexicon.lexicon_group
    exit_if_not_manager and return

    respond_to do |format|
      if @lexicon.update(lexicon_params)
        format.html { redirect_back fallback_location: lexicon_group_lexicons_path(@lexicon_group), notice: 'The concept was successfully updated.' }
        format.json { render :show, status: :ok, location: @lexicon }
      else
        format.html { render :edit }
        format.json { render json: @lexicon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lexicons/1
  # DELETE /lexicons/1.json
  def destroy
    @lexicon_group = @lexicon.lexicon_group
    exit_if_not_manager and return
    @lexicon.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: lexicon_group_lexicons_path(@lexicon_group), notice: 'The concept was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lexicon
      @lexicon = Lexicon.find(params[:id])
      @lexicon_group = @lexicon.lexicon_group
      @project = @lexicon_group.project
      exit_if_not_member and return false
    end

    def set_lexicon_group
      @lexicon_group = LexiconGroup.find(params[:lexicon_group_id])
      @project = @lexicon_group.project
      exit_if_not_member and return false
    end

    def set_top_menu
      @top_menu = 'lexicons'
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def lexicon_params
      params.require(:lexicon).permit(:ltype, :lexicon_id, :name, :lexicon_group_id)
    end
end
