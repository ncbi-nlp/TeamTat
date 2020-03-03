class RelationTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_relation_type, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:new, :create, :index]

  # GET /relation_types
  # GET /relation_types.json
  def index
    breadcrumb_for_projects(@project)
    semantic_breadcrumb @project.name, @project
    semantic_breadcrumb "Relation Types"
    @relation_types = @project.relation_types
  end

  # GET /relation_types/1
  # GET /relation_types/1.json
  def show
  end

  # GET /relation_types/new
  def new
    exit_if_not_manager and return
    breadcrumb_for_projects(@project)
    semantic_breadcrumb @project.name, @project
    semantic_breadcrumb "Relation Types", project_relation_types_path(@project)
    semantic_breadcrumb "new"
    @relation_type = RelationType.new
    @relation_type.color = RelationType.random_color
  end

  # GET /relation_types/1/edit
  def edit
    exit_if_not_manager and return
    @project = @relation_type.project
    breadcrumb_for_projects(@project)
    semantic_breadcrumb @project.name, @project
    semantic_breadcrumb "Relation Types", project_relation_types_path(@project)
    semantic_breadcrumb "edit"
  end

  # POST /relation_types
  # POST /relation_types.json
  def create
    exit_if_not_manager and return
    @relation_type = RelationType.new(relation_type_params)
    if params[:relation_type][:entity_type].present?
      @relation_type.entity_type = params[:relation_type][:entity_type].select{|a| a.present? }.join(",")
    end
    @relation_type.project_id = @project.id
    respond_to do |format|
      if @relation_type.save
        format.html { redirect_to project_relation_types_path(@project), notice: 'Relation type was successfully created.' }
        format.json { render :show, status: :created, location: @relation_type }
      else
        format.html { render :new }
        format.json { render json: @relation_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /relation_types/1
  # PATCH/PUT /relation_types/1.json
  def update
    exit_if_not_manager and return
    respond_to do |format|
      if @relation_type.update(relation_type_params)
        format.html { redirect_to project_relation_types_path(@project), notice: 'Relation type was successfully updated.' }
        format.json { render :show, status: :ok, location: @relation_type }
      else
        format.html { render :edit }
        format.json { render json: @relation_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /relation_types/1
  # DELETE /relation_types/1.json
  def destroy
    @project = @relation_type.project
    exit_if_not_manager and return
    @relation_type.destroy
    respond_to do |format|
      format.html { redirect_to project_relation_types_path(@project), notice: 'Relation type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_relation_type
      @relation_type = RelationType.find(params[:id])
      @project = @relation_type.project
    end

    def set_project
      @project = Project.find(params[:project_id])
      exit_if_not_member and return false
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def relation_type_params
      params.require(:relation_type).permit(:name, :color, :num_nodes, :project_id, :entity_type => [])
    end
end
