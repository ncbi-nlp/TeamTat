class AuditsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:create, :new, :index]
  before_action :set_audit, only: [:show, :edit, :delete]
  before_action :set_top_menu
  helper_method :sort_column, :sort_direction
  semantic_breadcrumb 'Projects', :projects_path

  # GET /audits
  # GET /audits.json
  def index
    if params[:document_id]
      @document = Document.find(params[:document_id])
      @project = @document.project      
      @audits = Audit.where('document_id = ?', params[:document_id])  
    elsif @project.present?
      @audits = @project.audits
    end

    if params[:user_id]
      @audits = @audits.where("user_id = ?", params[:user_id])
      @user = User.find(params[:user_id])
    end

    semantic_breadcrumb @project.name
    semantic_breadcrumb "Audits"
    @audits = @audits.order(sort_column + " " + sort_direction)
    @audits = @audits.page(params[:page])
  end

  # GET /audits/1
  # GET /audits/1.json
  def show
    semantic_breadcrumb @project.name
    semantic_breadcrumb "Audits", project_audits_path(@project)
    semantic_breadcrumb "#{@audit.id}"

  end

  # # GET /audits/new
  # def new
  #   @audit = Audit.new
  # end

  # # GET /audits/1/edit
  # def edit
  # end

  # # POST /audits
  # # POST /audits.json
  # def create
  #   @audit = Audit.new(audit_params)

  #   respond_to do |format|
  #     if @audit.save
  #       format.html { redirect_to @audit, notice: 'Audit was successfully created.' }
  #       format.json { render :show, status: :created, location: @audit }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @audit.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PATCH/PUT /audits/1
  # # PATCH/PUT /audits/1.json
  # def update
  #   respond_to do |format|
  #     if @audit.update(audit_params)
  #       format.html { redirect_to @audit, notice: 'Audit was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @audit }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @audit.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /audits/1
  # # DELETE /audits/1.json
  # def destroy
  #   @audit.destroy
  #   respond_to do |format|
  #     format.html { redirect_to audits_url, notice: 'Audit was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_audit
      @audit = Audit.find(params[:id])
      @project = @audit.project
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def audit_params
      params.require(:audit).permit(:user_id, :project_id, :document_id, :annotation_id, :relation_id, :message)
    end

    def set_project
      @project = Project.find(params[:project_id])
      exit_if_not_member and return false
    end

    def set_top_menu
      @top_menu = 'projects'
    end

    def sort_column
      Audit.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end


end
