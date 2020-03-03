class RelationsController < ApplicationController
  before_action :set_document
  before_action :set_relation, only: [:update, :destroy]
  before_action :authenticate_user!

  # GET /relations
  # GET /relations.json
  def index
    # @results = []
    # @document.bioc_doc.all_relations.each do |a|
    #   e = EntityUtil.get_relation_entity(a)
    #   a.locations.each do |l|
    #     @results << {did: @document.did, offset: l.offset, text: a.text, length: l.length, infons: a.infons }
    #   end
    # end
    @project = @document.project
    @version = params[:version] || @document.version
    @version = @version.to_i if @version.present?
    @is_manager = @project.manager?(current_user)

    if @is_manager
      @relations = @document.relations.where('`version`=?', @version)
    else
      @relations = @assign.relations
    end
    @relations = @relations.order("offset")
  end

  def create
    assign_id = @assign.id if @assign.present?
    Relation.transaction do 
      max_id = @document.relations.maximum('r_id_no') || 0;
      @relation = Relation.create!({
        r_id: "R#{max_id + 1}",
        r_id_no: max_id + 1,
        r_type: params[:type],
        user_id: current_user.id,
        note: params[:note] || "",
        infons: {},
        annotator: current_user.email_or_name,
        document_id: @document.id,
        assign_id: assign_id,
        passage: params[:passage_id],
        version: @document.version
      })
      if params[:nodes].present?
        order_no = 1
        params[:nodes].each do |n|
          node = n[1]
          @relation.nodes.create!({
            document_id: @document.id,
            version: @document.version,
            ref_id: (node[:ref_id] || 0).to_i,
            role: node[:role],
            order_no: order_no
          })
          order_no += 1
        end
        @relation.update_signature
        @relation.adjust_passage
      end
      @document.touch
    end
    respond_to do |format|
      format.html { redirect_to @relation, notice: 'The relation was successfully created.' }
      format.json { render :show, status: :ok, location: @relation }
    end
  end

  def update
    Relation.transaction do
      @relation.r_type = params[:type]
      @relation.note = params[:note] unless params[:no_update_node].present?
      @relation.user_id = current_user.id
      @relation.annotator = current_user.email_or_name
      logger.debug("FORCE UPDATE NODES #{params[:forceUpdateNodes]}")
      if params[:nodes].present? || params[:forceUpdateNodes] == "1"
        remaining_nodes = @relation.nodes.all.map{|n| n.id}
        idx = 1
        logger.debug("Remaining Nodes: #{remaining_nodes}")
        params[:nodes].each do |n|
          # logger.debug(n.inspect)
          # logger.debug(idx)
          node = n[1]
          record = @relation.nodes.where("ref_id = ?", node[:ref_id]).first
          if record.present?
            record.role = node[:role]
            record.order_no = idx
            record.save
            remaining_nodes.delete(record.id)
          else
            @relation.nodes.create!({
              document_id: @document.id,
              version: @relation.version,
              ref_id: node[:ref_id],
              role: node[:role],
              order_no: idx
            })
          end 
          idx += 1
        end if params[:nodes].present?
        @relation.nodes.where("id in (?)", remaining_nodes).delete_all if remaining_nodes.present?
        @relation.update_signature
        @relation.adjust_passage
      end
      @relation.save
      @document.touch
    end
    respond_to do |format|
      format.html { redirect_to @relation, notice: 'The relation was successfully updated.' }
      format.json { render :show, status: :ok, location: @relation }
    end
  end

  def destroy
    id = @relation.id
    @relation.destroy
    @document.touch
    respond_to do |format|
      format.html { redirect_to @document, notice: 'The relation was successfully deleted.' }
      format.json { render json: id, status: :ok }
    end

  end


private
  # Use callbacks to share common setup or constraints between actions.
  def set_relation
    @relation = Relation.find(params[:id])
  end

  def set_document
    if params[:document_id].present?
      @document = Document.find(params[:document_id])
      @assign = @document.user_assign(current_user)
      @project = @document.project
      exit_if_not_member and return false
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def relation_params
    params.require(:relation).permit(:document_id, :type, :nodes, :ref_id, :order_no)
  end
end
