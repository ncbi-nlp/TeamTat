class AssignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_assign, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:create, :new, :index, :download, :upload]
  before_action :set_top_menu
  helper_method :sort_column, :sort_direction
  semantic_breadcrumb 'Projects', :projects_path

  # GET /assigns
  # GET /assigns.json
  def index
    semantic_breadcrumb @project.name, @project
    semantic_breadcrumb "Assign"

    @assigns = @project.assigns
    @assigns_map = {}
    @assigns.each do |a|
      @assigns_map["#{a.document_id}-#{a.user_id}"] = a
    end
    @documents = @project.documents
    @users = @project.users.where("role=1").order('email asc')
  end

  # GET /assigns/1
  # GET /assigns/1.json
  def show
  end

  def download
    @assigns = @project.assigns
    @assigns_map = {}
    @assigns.each do |a|
      @assigns_map["#{a.document_id}-#{a.user_id}"] = a
    end
    @documents = @project.documents
    @users = @project.users.where("role=1").order('email asc')

    rows = []
    row = ['db_id', 'id']
    @users.each{|u| row << u.email_or_user_id}
    rows << row.join("\t")
    @documents.each do |d|
      row = [d.id, d.did]
      @users.each{|u| row << if @assigns_map["#{d.id}-#{u.id}"].nil? then 0 else 1 end }
      rows << row.join("\t")
    end
    send_data rows.join("\n"), filename: "assign#{@project.id}.tsv"
  end

  def upload
    if params[:file].present?
      if params[:file].respond_to?(:read)
        text = params[:file].read
      elsif params[:file].respond_to?(:path)
        text = File.read(params[:file].path)
      end
      text.gsub!(/\r\n?/, "\n")
      first = true
      insert_values = []
      headers = nil
      user_cache = {}
      text.each_line do |line|
        cols = line.strip.split("\t")
        d = cols[0]
        if !/\A\d+\z/.match(d)
          headers = cols
        else
          d = d.to_i
          cols.each_with_index do |c, idx|
            next if idx <= 1 || c != "1" 
            u = user_cache[headers[idx]]
            if u.blank?
              u = User.find_by_email_or_user_id(headers[idx])
              user_cache[headers[idx]] = u
            end
            pu = @project.project_users.where('user_id=?', u.id).first if u.present?
            insert_values << "(#{pu.id}, #{@project.id}, #{d}, #{u.id}, NOW(), NOW())" if pu.present?
          end
        end
      end
      Assign.transaction do 
        Assign.execute_sql("DELETE FROM assigns WHERE project_id = ?", @project.id)
        if !insert_values.empty?
          Assign.execute_sql("
            INSERT INTO assigns(project_user_id, project_id, document_id, user_id, created_at, updated_at) 
            VALUES #{insert_values.join(',')}
          ") 
        end
        ActiveRecord::Base.connection.execute("
          UPDATE projects
             SET 
             assigns_count = (SELECT count(1) FROM assigns WHERE assigns.project_id = projects.id)
          WHERE
            projects.id = #{@project.id}
        ")
        ActiveRecord::Base.connection.execute("
          UPDATE documents
             SET 
             assigns_count = (SELECT count(1) FROM assigns WHERE assigns.document_id = documents.id),
             done_count = 0
          WHERE
            documents.project_id = #{@project.id}
        ")
      end
    else
      return redirect_to project_assigns_path(@project), alert: 'Please select a file first'
    end
    redirect_to project_assigns_path(@project), notice: 'Assign was successfully created.'
  end

  # GET /assigns/new
  def new
    @assign = Assign.new
  end

  # GET /assigns/1/edit
  def edit
  end

  # POST /assigns
  # POST /assigns.json
  def create
    if @project.round_begin?
      return render json: {error: 'You cannot change assignments after a round begins'}, status: :unprocessable_entity 
    end

    requests = params[:list] || []
    assigns = @project.assigns.map{|a| "#{a.document_id}-#{a.user_id}"}

    insertSet = requests - assigns
    deleteSet = assigns - requests

    success = false   
    insert_values = insertSet.map do |id|
      ids = id.split('-')
      pu = @project.project_users.where('user_id=?', ids[1].to_i).first
      "(#{pu.id}, #{@project.id}, #{ids[0].to_i}, #{ids[1].to_i}, NOW(), NOW())"
    end
    delete_values = deleteSet.map do |id|
      ids = id.split('-')
      "(#{@project.id}, #{ids[0].to_i}, #{ids[1].to_i})"
    end
    Assign.transaction do 
      ActiveRecord::Base.connection.execute("
        INSERT INTO assigns(project_user_id, project_id, document_id, user_id, created_at, updated_at) VALUES #{insert_values.join(',')}
      ") unless insert_values.empty?

      ActiveRecord::Base.connection.execute("
        DELETE FROM assigns WHERE (project_id, document_id, user_id) IN (#{delete_values.join(',')})
      ") unless delete_values.empty?

      ActiveRecord::Base.connection.execute("
        UPDATE projects
           SET 
           assigns_count = (SELECT count(1) FROM assigns WHERE assigns.project_id = projects.id)
        WHERE
          projects.id = #{@project.id}
      ")
      ActiveRecord::Base.connection.execute("
        UPDATE documents
           SET 
           assigns_count = (SELECT count(1) FROM assigns WHERE assigns.document_id = documents.id)
        WHERE
          documents.project_id = #{@project.id}
      ")
      @project = Project.find(@project.id)
      success = true
    end
    # @assign = Assign.new(assign_params)

    respond_to do |format|
      if success
        format.html { redirect_to @assign, notice: 'Assign was successfully created.' }
        format.json { render json: {project: @project} }
      else
        format.html { render :new }
        format.json { render json: @assign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assigns/1
  # PATCH/PUT /assigns/1.json
  def update
    respond_to do |format|
      if @assign.update(assign_params)
        format.html { redirect_to @assign, notice: 'Assign was successfully updated.' }
        format.json { render :show, status: :ok, location: @assign }
      else
        format.html { render :edit }
        format.json { render json: @assign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assigns/1
  # DELETE /assigns/1.json
  def destroy
    @assign.destroy
    respond_to do |format|
      format.html { redirect_to assigns_url, notice: 'Assign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assign
      @assign = Assign.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assign_params
      params.require(:assign).permit(:project_id, :document, :user_id, :round, :done, :curatable)
    end

    def set_project
      @project = Project.find(params[:project_id])
      unless @project.manager?(current_user)
        respond_to do |format|
          format.html { redirect_back fallback_location: project_documents_path(@project), alert: "Cannot access the task assigns"}
          format.json { render json: {msg: 'Cannot access task assigns'}, status: 401 }
        end    
        return false
      end
    end
    def set_top_menu
      @top_menu = 'projects'
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sort_column
      Assign.column_names.include?(params[:sort]) ? params[:sort] : "document_id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
