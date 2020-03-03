class TasksController < ApplicationController
  before_action :authenticate_user!

  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:new, :create, :index, :partial]
  # GET /tasks
  # GET /tasks.json
  def index
    breadcrumb_for_projects(@project)
    semantic_breadcrumb @project.name, @project
    semantic_breadcrumb "Tasks"
    @tasks = @project.tasks
  end

  def partial
    @tasks = @project.tasks
    respond_to do |format|
      format.html {render layout: false}
      format.json
      format.xml {render xml: @document.xml}
    end
  end
  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    if @project.busy?
      return redirect_back fallback_location: project_tasks_path(@project), alert: "Cannot create a new task because the project is busy"
    end
    breadcrumb_for_projects(@project)
    semantic_breadcrumb @project.name, @project
    semantic_breadcrumb "Create a Task"
    @task_type = params[:task_type] || "0"
    @task = Task.new
    @task.task_type = @task_type.to_i

    @lexicon_options = @project.lexicon_groups.map{|l| l.option_item}
    if @task_type == "1"
      @lexicon_options = [["N/A (or choose not to select)", 0]] + @lexicon_options
    end
    @models = @project.models.select{|m| m.status == 'Done'}
    @target_document = @project.documents
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    if params[:task][:task_type] == "1" && (params[:output_model_name].blank? || params[:output_model_name].strip.blank?)
      @task = Task.new
      @task.task_type = 1
      @task.errors.add(:base, :name_or_email_blank, message: "Nothing entered. Please enter a model name.")
      @task.lexicon_group_id = params[:task][:lexicon_group_id]
      @lexicon_options = [["- None -", 0]] + current_user.lexicon_groups.map{|l| l.option_item}
      @models = current_user.models
      return render :new
    end
    @task = @project.create_task(params)
    respond_to do |format|
      unless @task.nil?
        format.html { redirect_to project_tasks_path(@project), notice: 'The task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        logger.debug("Fail")
        format.html { render json: "error" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @project = @task.project
    if @task.can_cancel?
      @task.destroy
      @project.unlock
      success = true
    else
      success = false
    end

    respond_to do |format|
      if success
        format.html { redirect_back fallback_location: project_tasks_path(@project), notice: 'The task was successfully canceled.' }
        format.json { head :no_content }
      else
        format.html { redirect_back fallback_location: project_tasks_path(@project), alert: 'Sorry, the task cannot be canceled.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
      redirect_to :back, alert: 'Not authorized' unless @project.available?(current_user)
    end


    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:user_id, :project_id, :task_type)
    end
end
