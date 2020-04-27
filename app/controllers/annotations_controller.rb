class AnnotationsController < ApplicationController
  before_action :set_document
  before_action :set_annotation, only: [:update, :destroy]
  before_action :authenticate_user!

  # GET /annotations
  # GET /annotations.json
  def index
    # @results = []
    # @document.bioc_doc.all_annotations.each do |a|
    #   e = EntityUtil.get_annotation_entity(a)
    #   a.locations.each do |l|
    #     @results << {did: @document.did, offset: l.offset, text: a.text, length: l.length, infons: a.infons }
    #   end
    # end
    @project = @document.project
    @version = params[:version] || @document.version
    @version = @version.to_i if @version.present?
    @is_manager = @project.manager?(current_user)

    if @is_manager || @project.collaborate_round
      @annotations = @document.annotations.where('`version`=?', @version)
    else
      @annotations = @assign.annotations
    end
    @annotations = @annotations.order("offset")
  end

  # GET /annotations/1
  # GET /annotations/1.json
  def show
    @entity_types = EntityType.where(project_id: @document.project_id)
    @document.adjust_offset(true)
  end

  # GET /annotations/new
  def new
  end

  # GET /annotations/1/edit
  def edit
  end

  # POST /annotations
  # POST /annotations.json
  def create
    @text = (params[:text] || "").strip
    @offset = (params[:offset] || "-1").to_i
    @concept = params[:concept] || ""
    @type = params[:type] || ""
    @note = params[:note] || ""
    assign_id = @assign.id if @assign.present?
    @concept = @document.project.normalize_concept_id(@concept, @type)

    @is_manager = @project.manager?(current_user)
    if @project.collaborate_round?
      annotator = @document.assigns.map{|a| a.user.email_or_name}.uniq.sort.join(',')
    else
      annotator = current_user.email_or_name
    end

    Annotation.transaction do
      max_id = @document.annotations.maximum('a_id_no') || 0;
      @annotation = Annotation.create!({
        a_id: max_id + 1,
        a_id_no: max_id + 1,
        a_type: @type, 
        concept: @concept,
        assign_id: assign_id,
        user_id: current_user.id,
        content: @text,
        note: params[:note] || "",
        offset: (params[:offset] || "-1").to_i,
        passage: params[:passage_id],
        document_id: @document.id,
        project_id: @document.project_id,
        annotator: annotator,
        version: @document.version,
        review_result: 'agreed',
        infons: {}
      });
      if @project.collaborate_round
        @annotation.compute_review_result(nil)
      else
        @annotation.compute_review_result(@assign)
      end
      @document.touch
    end

    # @ret = @document.add_annotation(@current_user.email, @text, @offset, @type, @concept, @note)
    # @entity_types = EntityType.where(project_id: @document.project_id)
    @document.create_audit(current_user, 'Create annotation', params.to_json, @annotation.to_json)
    respond_to do |format|
      format.html { redirect_to @annotation, notice: 'The annotation was successfully created.' }
      format.json { render :show, status: :ok, location: @annotation }
    end
  end

  # PATCH/PUT /annotations/1
  # PATCH/PUT /annotations/1.json
  def update
    concept = params[:concept] || ""
    type = params[:type] || ""
    note = params[:note] || ""
    no_update_note = params[:no_update_note] 
    review_result = (params[:review_result] || 1).to_i
    type.strip!
    concept = @document.project.normalize_concept_id(concept, type)
    @error = nil  
    if @project.collaborate_round?
      annotator = @document.assigns.map{|a| a.user.email_or_name}.uniq.sort.join(',')
    else
      annotator = current_user.email_or_name
    end
  
    Document.transaction do 
      if (params[:mode] == "true" || params[:mode] == "1" || params[:mode] == "concept")
        logger.debug("update_concept")

        if @assign.present? 
          targets = Annotation.execute_sql("
            SELECT id FROM annotations 
            WHERE assign_id = ? AND version = ? AND concept = ? AND a_type = ?
          ", @assign.id, @annotation.version, @annotation.concept, @annotation.a_type)
        elsif @project.manager?(current_user) || @project.collaborate_round
          targets = Annotation.execute_sql("
            SELECT id FROM annotations 
            WHERE document_id = ? AND version = ? AND concept = ? AND a_type = ?
          ", @document.id, @annotation.version, @annotation.concept, @annotation.a_type)
        end

        @ids = targets.map{|e| e[0]}

        # @document.update_concept(@current_user.email, params[:id], @type, @concept, @note, @no_update_note)
        set_sql = "concept=?, a_type=?"
        values = [concept, type]
        set_sql = set_sql + ", review_result=? "
        values << review_result

        if no_update_note.blank? || no_update_note == false
          set_sql = set_sql + ",note=? "
          values << note
        end 
        sql = "UPDATE annotations
          SET #{set_sql}, annotator=?, updated_at=? 
          WHERE "
        values << annotator
        values << Time.now
        if @assign.present? 
          sql = sql + " assign_id = ? and version = ? "
          values << @annotation.assign_id
          values << @annotation.version
        elsif @project.manager?(current_user) || @project.collaborate_round
          sql = sql + " document_id = ? and version = ? "
          values << @document.id
          values << @annotation.version
        end
        sql = sql +  " AND concept = ? AND a_type = ?"
        values << @annotation.concept
        values << @annotation.a_type

        args = [sql] + values
        ret = Annotation.execute_sql(*args)
      else
        logger.debug("update_mention")
        @annotation.concept = concept
        @annotation.a_type = type
        @annotation.note = note if no_update_note.blank? || no_update_note == false
        @annotation.annotator = annotator
        @annotation.review_result = review_result
        if !@annotation.save
          @error = @annotation.errors
        end
        @ids = [@annotation.id]
      end

      if @error.blank? && params[:annotate_all] == "all"
        text = (params[:text] || "").strip
        case_sensitive = (params[:case_sensitive] == "y")
        whole_word = (params[:whole_word] == "y")
        result = @document.annotate_all_by_text_into_db(@assign, current_user, annotator, text, type, concept, case_sensitive, whole_word, review_result, note)
        @ids += result
      end
      @annotations = Annotation.where("id in (?)", @ids).all
      logger.debug(@ids.inspect)
      logger.debug(@annotations.inspect)
      @document.touch
    end
    respond_to do |format|
      if @error.blank?
        @document.create_audit(current_user, "Update annotation", params.to_json, @ids.join(","))
        format.html { redirect_to @annotation, notice: 'The annotation was successfully updated.' }
        format.json { render :index, status: :ok, location: document_annotations_path(@document) }
      else
        format.html { render :edit }
        format.json { render json: @error, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /annotations/1
  # DELETE /annotations/1.json
  def destroy
    @mode = params[:deleteMode]
    type = params[:type] || ""
    concept = params[:concept] || ""
    type.strip!
    concept.strip!

    Document.transaction do 
      if @mode == "batch"
        @ids = params[:ids]
        if @document.has_reference_relation?(@ids)
          return render json: 'Cannot delete annotation because there is a relation that refers to this node' , status: 422 
        end
        ret = Annotation.execute_sql("DELETE FROM annotations WHERE id in (?)", @ids)
      elsif @mode == "concept"
        if @assign.present?
          targets = Annotation.execute_sql("
            SELECT id FROM annotations 
            WHERE assign_id = ? AND version = ? AND concept = ? AND a_type = ?
          ", @assign.id, @annotation.version, @annotation.concept, @annotation.a_type)
        elsif @project.manager?(current_user) || @project.collaborate_round
          targets = Annotation.execute_sql("
            SELECT id FROM annotations 
            WHERE document_id = ? AND version = ? AND concept = ? AND a_type = ?
          ", @document.id, @annotation.version, @annotation.concept, @annotation.a_type)
        end
        @ids = targets.map{|e| e[0]}
        if @document.has_reference_relation?(@ids)
          return render json: 'Cannot delete annotation because there is a relation that refers to this node' , status: 422 
        end
        ret = Annotation.execute_sql("DELETE FROM annotations WHERE id in (?)", @ids)
      elsif @mode == "mention"
        if @document.has_reference_relation?([@annotation.id])
          return render json: 'Cannot delete annotation because there is a relation that refers to this node' , status: 422 
        end
        @ids = [@annotation.id]
        @annotation.destroy
      end
      @document.touch
    end
    @document.create_audit(current_user, "Delete annotation", params.to_json, @ids.join(","))

    # @annotation.destroy
    respond_to do |format|
      format.html { redirect_to @document, notice: 'The annotation was successfully deleted.' }
      format.json { render json: @ids, status: :ok }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_annotation
      @annotation = Annotation.find(params[:id])
    end

    def set_document
      if params[:document_id].present?
        @document = Document.find(params[:document_id])
        @project = @document.project
        @assign = @document.user_assign(current_user) unless @project.collaborate_round
        exit_if_not_member and return false
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def annotation_params
      params.require(:annotation).permit(:document_id, :entity_type, :concept_id)
    end
end
