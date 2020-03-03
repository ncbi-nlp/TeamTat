class StatisticsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_top_menu
  helper_method :sort_column, :sort_direction
  semantic_breadcrumb 'Projects', :projects_path
  before_action :set_version

  def index
    @documents = @project.documents
    @num_documents = @documents.size
    if @version == 0 or (@version == @project.round && @project.finalized)
      @result = @project.entities_stat(@version)
      render :entities
      return
    end
    @type = params[:type] || "A"
    semantic_breadcrumb @project.name
    @documents = @project.documents
    if @type == "A"
      render :annotation_agree
    else
      render :relation_agree
    end
  end

  private
    def set_project
      @project = Project.find(params[:project_id])
      exit_if_not_member and return false
    end

    def set_top_menu
      @top_menu = 'projects'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sort_column
      Document.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def set_version
      @version = params[:version] || @project.round
      @version = @version.to_i
      if @version < 0 or @version > @project.round 
        @version = @project.round
      end
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
