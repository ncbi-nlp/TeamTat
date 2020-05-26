require 'zip'

class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_project, only: [:show, :edit, :update, :destroy, :download, :buttons,
                                :empty, :delete_all_annotations, :done_all, :reorder, 
                                :start_round, :start_round2, :cancel_round, :end_round, :lock, :unlock, :final_merge
                              ]
  before_action :set_top_menu
  helper_method :sort_column, :sort_direction
  
  # GET /projects
  # GET /projects.json
  def index
    @projects = @user.projects.select('projects.*, project_users.role as role')
    if params[:name].present?
      @projects = @projects.where("name = ?", params[:name])
    end
    @projects = @projects.order(sort_column + " " + sort_direction)

    respond_to do |format|
      format.html
      format.json {render json:@projects.as_json(only: [:id, :name, :documents_count])}
    end
  end

  def partial
    @projects = @user.projects.all
    @projects = @projects.order(sort_column + " " + sort_direction)
    respond_to do |format|
      format.html {render layout: false}
      format.json {render json:@projects.as_json(only: [:id, :name, :documents_count])}
      format.xml {render xml: @document.xml}
    end
  end

  def buttons
    render layout: false
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    respond_to do |format|
      format.html {
        redirect_to project_documents_path(@project)
      }
      format.json
    end
  end
  
  def lock
    exit_if_not_manager and return
    exit_if_project_locked and return

    @project.lock
    respond_to do |format|
      format.html { redirect_to @project, notice: 'Project is locked' }
      format.json { render json: {documents: Document.find_by_sql(["SELECT id FROM documents WHERE project_id = ?", @project.id]).map{|l| l.id}} }
    end
  end

  def unlock
    exit_if_not_manager and return
    @project.unlock
    respond_to do |format|
      format.html { redirect_to @project, notice: 'Project is unlocked' }
      format.json { render json: "ok"}
    end
    
  end

  def start_round
    exit_if_not_manager and return
    exit_if_project_unlocked and return

    if !@project.round_available?
      return redirect_to @project, notice: 'Not ready to start the round'
    end

    respond_to do |format|
      if @project.start_round
        format.html { redirect_to @project, notice: 'New annotation round has been began.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def start_round2
    exit_if_not_manager and return
    exit_if_project_unlocked and return

    if !@project.round_available?
      return redirect_to @project, notice: 'Not ready to start the round'
    end

    respond_to do |format|
      if @project.start_round(true)
        format.html { redirect_to @project, notice: 'New annotation round has been began.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def cancel_round
    exit_if_not_manager and return
    exit_if_project_locked and return

    if @project.round <= 0
      return redirect_to @project, notice: 'Not ready to cancel the round'
    end

    respond_to do |format|
      if @project.cancel_round
        format.html { redirect_to @project, notice: 'Cancel the annotation round.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  def end_round
    exit_if_not_manager and return
    exit_if_project_unlocked and return

    if !@project.round_begin?
      return redirect_to @project, notice: 'Not ready to end the round'
    end

    respond_to do |format|
      if @project.end_round
        format.html { redirect_to @project, notice: 'Annotation round has been finished.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def final_merge
    exit_if_not_manager and return
    exit_if_project_unlocked and return

    if !@project.round_available? 
      return redirect_to @project, notice: 'Not ready to merge a final version'
    end

    respond_to do |format|
      if @project.final_merge
        format.html { redirect_to @project, notice: 'Annotation round has been finished.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end
  def load_samples
    Project.load_samples(@user)
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'The sample projects were successfully created.' }
    end
  end
  # GET /projects/new
  def new
    semantic_breadcrumb 'Projects', :projects_path
    semantic_breadcrumb 'New'
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = @user.projects.new(project_params)
    @project.collaborates = [false]
    if @project.save
      success = @project.project_users.create!({user_id: current_user.id, role: 'project_manager'})
    else
      success = false
    end

    respond_to do |format|
      if success
        format.html { redirect_to project_documents_path(@project), notice: 'The project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def download
    filename = "#{@project.id}-#{Time.now.to_i}.zip"
    temp_file = Tempfile.new(filename)
    names = []
    version = params[:version] || @project.round
    begin
      #This is the tricky part
      #Initialize the temp file as a zip file
      Zip::OutputStream.open(temp_file) { |zos| }
     
      #Add files to the zip file as usual
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
        @project.documents.each do |d|
          name = "#{d.did || d.id}_v#{version}.xml"
          if names.include?(name)
            name = "#{d.did}_#{d.id}_v#{version}.xml"
          end
          zip.get_output_stream(name) { |os| os.write d.get_xml(version) }
          names << name
        end
      end
      zip_data = File.read(temp_file.path)
 
      #Send the data to the browser as an attachment
      #We do not send the file directly because it will
      #get deleted before rails actually starts sending it
      send_data(zip_data, filename: "p#{@project.id}_#{@project.name}_v#{version}.zip", type: 'application/zip')
    ensure
      temp_file.close
      temp_file.unlink
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to project_documents_path(@project), notice: 'The project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy_all
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'The project was successfully removed.' }
      format.json { head :no_content }
    end
  end

  def reorder
    # @user = @project.user

    if params[:batch_id].present?
      Project.transaction do 
        last_order_no = @project.documents.where("order_no < 999999").maximum('order_no')
        last_order_no = 0 if last_order_no.nil?
        if params[:batch_id] == "999999"
          no = last_order_no + 1
          @project.documents.where("order_no = 999999").order("batch_id ASC, batch_no DESC, id ASC").each do |d|
            d.order_no = no
            d.save!
            no += 1
          end
        else
          @project.documents
            .where("batch_id = ? and order_no = 999999", params[:batch_id])
            .update_all("order_no = batch_no + #{last_order_no}")
        end
      end
    else
      # src = @project.order_no
      # if params[:dest] == "last"
      #   dest = @user.projects.size
      # else
      #   dest = params[:dest].to_i
      # end
      # Project.transaction do 
      #   if dest > @project.order_no
      #     @user.projects.where("order_no > ? and order_no <= ?", src, dest).update_all("order_no = order_no - 1")
      #     @project.order_no = dest
      #     @project.save!
      #   elsif dest < @project.order_no
      #     @user.projects.where("order_no >= ? and order_no < ?", dest, src).update_all("order_no = order_no + 1")
      #     @project.order_no = dest
      #     @project.save!
      #   end
      # end
    end
    respond_to do |format|
      format.html { redirect_back fallback_location: projects_path, notice: 'The project was successfully reordered.' }
      format.json { head :no_content }
    end      
  end


  def empty
    @project.documents.destroy_all
    @project.update_annotation_count
    respond_to do |format|
      format.html { redirect_to project_documents_path(@project), notice: 'All documents were successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def delete_all_annotations
    logger.debug(params.inspect)
    Project.transaction do 
      @project.documents.each {|d| d.delete_all_annotations}
    end
    
    if params[:from] == "list"
      return_path = projects_url
    else
      return_path = @project
    end
    respond_to do |format|
      format.html { redirect_to return_path, notice: 'Annotations were successfully deleted.'}
      format.json { render json: {ok: true} }
    end    
  end

  def done_all
    Document.transaction do 
      Document.where('project_id = ?', @project.id).update_all(done: params[:value].to_s == 'true')
    end
    redirect_to @project, notice: 'Successfully changed.'
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_user
      if params[:user_id].present? && current_user.super_admin?
        @user = User.find(params[:user_id]) 
      else
        @user = current_user
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :desc, :round, :documents_count, :cdate, :key, :source, :xml_url, :annotations_count, :order_no, :status, :enable_audit)
    end

    def set_top_menu
      @top_menu = 'projects'
    end

    def sort_column
      %w(role name round documents_count annotations_count).include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
