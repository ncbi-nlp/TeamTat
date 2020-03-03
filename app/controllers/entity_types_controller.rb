class EntityTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_entity_type, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:new, :create, :index, :import_default_color]
  before_action :prepare_options, only: [:new, :create, :update, :edit]
  # GET /entity_types
  # GET /entity_types.json
  def index
    breadcrumb_for_projects(@project)
    semantic_breadcrumb @project.name, @project
    semantic_breadcrumb "Entity Types"
    @entity_types = @project.entity_types
  end

  # GET /entity_types/1
  # GET /entity_types/1.json
  def show
  end

  # GET /entity_types/new
  def new
    exit_if_not_manager and return
    breadcrumb_for_projects(@project)
    semantic_breadcrumb @project.name, @project
    semantic_breadcrumb "Entity Types", project_entity_types_path(@project)
    semantic_breadcrumb "new"
    @entity_type = EntityType.new
    @entity_type.color = EntityType.random_color
  end

  # GET /entity_types/1/edit
  def edit
    exit_if_not_manager and return
    @project = @entity_type.project
    breadcrumb_for_projects(@project)
    semantic_breadcrumb @project.name, @project
    semantic_breadcrumb "Entity Types", project_entity_types_path(@project)
    semantic_breadcrumb "edit"
    
  end

  # POST /entity_types
  # POST /entity_types.json
  def create
    exit_if_not_manager and return
    @entity_type = EntityType.new(entity_type_params)
    @entity_type.project_id = @project.id
    respond_to do |format|
      if @entity_type.save
        format.html { redirect_to project_entity_types_path(@project), notice: 'The entity type was successfully created.' }
        format.json { render :show, status: :created, location: @entity_type }
      else
        format.html { render :new }
        format.json { render json: @entity_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def import_default_color
    exit_if_not_manager and return
    EntityType.transaction do 
      EntityType::DEFAULT_COLORMAP.each do |k, c|
        found = false
        @project.entity_types.each do |e|
          name = e.name.strip.downcase
          logger.debug("CHECK NAME #{name} == #{k}")
          if name == k
            e.color = c
            e.name = EntityType::DEFAULT_NAMEMAP[k]
            e.save
            found = true
          end
        end
        if !found
          @project.entity_types.create!({name: EntityType::DEFAULT_NAMEMAP[k], color: c})
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to project_entity_types_path(@project), notice: 'The entity type was successfully imported.' }
    end
  end


  # PATCH/PUT /entity_types/1
  # PATCH/PUT /entity_types/1.json
  def update
    @project = @entity_type.project
    exit_if_not_manager and return
    respond_to do |format|
      if @entity_type.update(entity_type_params)
        format.html { redirect_to project_entity_types_path(@project), notice: 'The entity type was successfully updated.' }
        format.json { render :show, status: :ok, location: @entity_type }
      else
        format.html { render :edit }
        format.json { render json: @entity_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entity_types/1
  # DELETE /entity_types/1.json
  def destroy
    @project = @entity_type.project
    exit_if_not_manager and return
    @entity_type.destroy
    respond_to do |format|
      format.html { redirect_to project_entity_types_path(@project), notice: 'The entity type was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def prepare_options
      @options = [
        ["-- none --",  ""],
        ["MESH:", "MESH:"],
        ["GENE:", "GENE:"]
      ]
      @project.entity_types.each do |e|
        item = [e.prefix, e.prefix]
        @options << item unless @options.include?(item)
      end
    end
    def set_entity_type
      @entity_type = EntityType.find(params[:id])
      @project = @entity_type.project
    end

    def set_project
      @project = Project.find(params[:project_id])
      exit_if_not_member and return false
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_type_params
      params.require(:entity_type).permit(:project_id, :name, :color, :prefix)
    end
end
