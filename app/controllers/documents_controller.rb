class DocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:create, :new, :index]
  before_action :set_document, only: [:show, :edit, :partial, :update, 
                  :destroy, :verify, :delete_all_annotations, 
                  :reorder, :correct_pmc_id, :prev, :next,
                  :done, :curatable, :attach, :detach, :simple_merge, :final_merge, :start_round, :start_round2]
  before_action :set_top_menu
  helper_method :sort_column, :sort_direction
  semantic_breadcrumb 'Projects', :projects_path

  # GET /documents
  # GET /documents.json
  def index
    semantic_breadcrumb @project.name
    if @project.manager?(current_user)
      @documents = @project.documents
    else
      ids = @project.assigns.where('user_id = ?', current_user.id).all.map{|d| d.document_id}
      @documents = Document.where('id in (?)', ids)
    end
    @documents = @documents.where("did = ?", params[:did]) if params[:did].present?
    @documents = @documents.where("done = ?", params[:done] == "true") if params[:done].present?
    @documents = @documents.where("curatable = ?", params[:curatable] == "true") if params[:curatable].present?
    @documents.includes(:assigns)
    if params[:term].present?
      @documents = @documents.where("did like ? or title like ? or xml like ?", "%#{params[:term]}%", "%#{params[:term]}%", "%#{params[:term]}%")
    end

    if sort_column == "default"
      @documents = @documents.order("batch_id DESC, batch_no ASC, id DESC")
    else    
      @documents = @documents.order(sort_column + " " + sort_direction)
    end
    @documents = @documents.order("batch_id DESC, batch_no ASC, id DESC")
    unless request.format.json?
      # @documents = @documents.order("batch_id DESC, batch_no ASC, id DESC").page(params[:page])
      @documents = @documents.page(params[:page])
    end  
  end

  def prev
    prev = nil
    @project.documents.order("batch_id DESC, batch_no ASC, id DESC").each do |d|
      if prev.present? && d.id == @document.id
        respond_to do |format|
          format.html { redirect_to document_path(prev) }
          format.json { render json: prev.id, status: 200}
        end
        return
      end
      prev = d
    end
    respond_to do |format|
      format.html { redirect_to document_path(@document), alert: 'This is the first document'}
      format.json { render json: -1, status: 200}
    end
  end

  def next
    found = false
    @project.documents.order("batch_id DESC, batch_no ASC, id DESC").each do |d|
      if found 
        respond_to do |format|
          format.html { redirect_to document_path(d.id) }
          format.json { render json: d.id, status: 200}
        end
        return
      end
      if d.id == @document.id
        found = true
      end
    end
    respond_to do |format|
      format.html { redirect_to document_path(@document), alert: 'This is the last document'}
      format.json { render json: -1, status: 200}
    end    
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @project = @document.project
    # @document.adjust_offset(true)
    @figure_cache = []
    @version = params[:version] || @document.version
    @version = @version.to_i if @version.present?
    @is_manager = @project.manager?(current_user)

    if @is_manager
      @assigns = @document.assigns.includes(:user)
    else
      @assign = @document.user_assign(current_user)
      if @assign.blank?
        respond_to do |format|
          format.html { redirect_back fallback_location: @project, alert: "Cannot access the document"}
          format.json { render json: {msg: 'Cannot access the document'}, status: 401 }
          format.xml { render xml: "<xml></xml>", status: 401 }
        end  
        return 
      end
    end
    
    logger.debug("Project collaborate_round = #{@project.collaborate_round}")
    if @project.round_begin? && @assign.present? && !@project.collaborate_round
      @annotations = @assign.annotations.where('`version`=?', @version)
      @relations =  @assign.relations.where('`version`=?', @version).includes(:nodes)
    else
      @annotations = @document.annotations.where('`version`=?', @version)
      @relations =  @document.relations.where('`version`=?', @version).includes(:nodes)
    end
    @document.create_audit(current_user, 'open document') unless @is_manager
    if @document.bioc_doc.infons.present? && @document.infons.blank?
      @document.infons = @document.bioc_doc.infons
      @document.save
    end
    logger.debug("DOC INFONS = #{@document.infons.inspect}")
    respond_to do |format|
      format.html
      format.json {render json: @document.get_json(@version)}
      format.xml {render xml: @document.merge_xml(@version, current_user)}
    end
  end

  def partial
    @document.adjust_offset(true)
    unless @document.project.available?(current_user)
      return render text: ""
    end
    respond_to do |format|
      format.html {render layout: false}
      format.json
      format.xml {render xml: @document.xml}
    end
  end

  # GET /documents/new
  def new
    @document = Document.new
    semantic_breadcrumb @project.name, @project
    semantic_breadcrumb "Add Documents"
  end

  # GET /documents/1/edit
  def edit
  end

  def check
    pmid = params[:id]
    if pmid.start_with?('PMC')
      url = "https://www.ncbi.nlm.nih.gov/pmc/articles/" + pmid
    else
      url = "https://www.ncbi.nlm.nih.gov/pubmed/" + pmid
    end
    response = HTTParty.get(url)
    logger.debug(response.code)

    if response.code == 404
      message = "not exist ID"
    else 
      message = "cannot retrieve (not open-accessible? or internal error?). Please try again or check <a href='" + url + "'>" + url + "</a>"
    end
    respond_to do |format|
      format.json { render json: {message: message} }
    end    
  end

  def verify
    @project = @document.project
    render json: @document.verify
  end

  def delete_all_annotations
    @project = @document.project
    unless @project.available?(current_user)
      respond_to do |format|
        format.html { redirect_to projects_path, error: "Cannot access the document"}
        format.json { render json: {}, status: 401 }
      end    
      return
    end
    ret = @document.delete_all_annotations
    @project.update_annotation_count
    respond_to do |format|
      format.html { redirect_to @project, notice: 'Annotations were successfully deleted.'}
      format.json { render json: {ok: true} }
    end    
  end

  def done
    @project = @document.project
    Document.transaction do 
      if @project.collaborate_round
        Project.execute_sql("UPDATE assigns SET done = ? WHERE document_id = ?", params[:value].to_s.downcase == "true", @document.id)
      else
        @assign = @document.assigns.where('user_id = ?', current_user.id).first
        if @assign.present? && @assign.done != params[:value]
          @assign.done = params[:value]
          @assign.save!          
        end
      end
      @project.check_done
      @document.update_done_count
    end
    render json: @document
  end

  def curatable
    @project = @document.project
    Document.transaction do 
      if @project.collaborate_round
        Project.execute_sql("UPDATE assigns SET curatable = ? WHERE document_id = ?", params[:value].to_s.downcase == "true", @document.id)
      else
        @assign = @document.assigns.where('user_id = ?', current_user.id).first
        if @assign.present?
          @assign.curatable = params[:value]
          @assign.save!
        end
      end
      @document.update_curatable_count
    end
    render json: @document
  end

  # POST /documents
  # POST /documents.json
  def create
    batch_id = params[:batch_id]
    if batch_id.blank?
      ub = UploadBatch.create!
      batch_id = ub.id
    end

    unless @project.available?(current_user)
      if request.format.json?
        render json: {error: "You're not authorized"}, status: 401
        return
      else
        redirect_to "/", error: "Cannot access the document"
        return
      end
    end
    
    logger.debug(params.inspect)
    if params[:file].present?
      error, dids = @project.upload_from_file(params[:file], batch_id, params[:replace])
    elsif params[:pmid].present?
      error, dids = @project.upload_from_pmids(params[:pmid], batch_id, params[:id_map])
    end
    logger.debug("RET === #{error.inspect}")
    
    respond_to do |format|
      if error.nil?
        format.html { redirect_to @project, notice: 'Document was successfully created.' }
        format.json {  render json: {ok: true, ids: dids, batch_id: batch_id}, status: :created }
      else
        format.html { redirect_to @project, alert: 'Failed to create document (PMID: does not exist)' }
        format.json { render json: {error: error}, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    @project = @document.project
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_back fallback_location: project_documents_path(@project), notice: 'The document was successfully updated.' }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit }
        format.json { render json: {error: @document.errors}, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @project = @document.project
    @document.destroy
    @project.update_annotation_count
    respond_to do |format|
      format.html { redirect_back fallback_location: project_documents_path(@project), notice: 'The document was successfully removed.' }
      format.json { head :no_content }
    end
  end

  def reorder
    @project = @document.project
    src = @document.order_no
    if params[:dest] == "last"
      dest = @project.documents.size
    else
      dest = params[:dest].to_i
    end
    Document.transaction do 
      if dest > @document.order_no
        @project.documents.where("order_no > ? and order_no <= ?", src, dest).update_all("order_no = order_no - 1")
        @document.order_no = dest
        @document.save!
      elsif dest < @document.order_no
        @project.documents.where("order_no >= ? and order_no < ?", dest, src).update_all("order_no = order_no + 1")
        @document.order_no = dest
        @document.save!
      end
    end
    respond_to do |format|
      format.html { redirect_back fallback_location: project_documents_path(@project), notice: 'The document was successfully reordered.' }
      format.json { head :no_content }
    end      
  end

  def correct_pmc_id
    ret = @document.correct_pmc_id
    render json: {result: ret}
  end

  def attach
    exit_if_not_manager and return
    exit_if_project_unlocked and return

    @document.get_xml()
    render json: {result: 'success'}
  end

  def detach
    exit_if_not_manager and return
    exit_if_project_unlocked and return

    @document.detach_annotations_relations()
    render json: {result: 'success'}
  end

  def start_round
    exit_if_not_manager and return
    exit_if_project_unlocked and return
    @document.start_round(params[:version])
    render json: {result: 'success'}
  end

  def start_round2
    exit_if_not_manager and return
    exit_if_project_unlocked and return
    @document.start_round(params[:version], true)
    render json: {result: 'success'}
  end

  def simple_merge
    exit_if_not_manager and return
    exit_if_project_unlocked and return

    @document.simple_merge
    render json: {result: 'success'}
  end

  def final_merge
    exit_if_not_manager and return
    exit_if_project_unlocked and return

    @document.final_merge(params[:version])
    render json: {result: 'success'}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
      @project = @document.project
      exit_if_not_member and return false
    end
    

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:project_id, :did, :user_updated_at, :tool_updated_at, :annotations_count)
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
      Document.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

end
