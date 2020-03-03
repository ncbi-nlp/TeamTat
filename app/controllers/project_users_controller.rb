class ProjectUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:create, :new, :index]
  before_action :set_project_user, only: [:show, :edit, :update, :destroy]
  before_action :set_top_menu
  helper_method :sort_column, :sort_direction
  semantic_breadcrumb 'Projects', :projects_path

  # GET /project_users
  # GET /project_users.json
  def index
    semantic_breadcrumb @project.name
    @project_users = @project.project_users.joins(:user).select('users.name as name, users.email as email, project_users.*')
    @project_users = @project_users.order(sort_column + " " + sort_direction)
    @project_users = @project_users.page(params[:page])
  end

  # GET /project_users/1
  # GET /project_users/1.json
  def show
  end

  # GET /project_users/new
  def new
    exit_if_not_manager and return
    @project_user = ProjectUser.new
  end

  # GET /project_users/1/edit
  def edit
  end

  # POST /project_users
  # POST /project_users.json
  def create
    exit_if_not_manager and return
    @email = params[:project_user][:email]
    @name = params[:project_user][:name]
    @type = params[:type] || "email"

    if @type == "anonymous"
      @name = @name.strip
      if @name.blank?
        return redirect_to project_project_users_path(@project), alert: "'#{@name}' is not a valid nickname"
      end
      @user = User.new_anonymous_user(@name)
    else
      if (@email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i).nil?
        return redirect_to project_project_users_path(@project), alert: "'#{@email}' is not a valid email address"
      end

      @user = User.where("email = ?", @email).first

      if @user.nil?
        @user = User.new({email: @email, name: @email.split("@")[0]})
        @user.skip_password_validation = true
        @user.generate_random_ui_avatar if @user.image.blank?
        @user.save
        # return redirect_to project_project_users_path(@project), alert: "Not exist email address (#{@email})"
      end
    end

    if @project.available?(@user)
      return redirect_to project_project_users_path(@project), alert: "Already participated user (#{@email})"
    end

    @project_user = ProjectUser.new({
      user_id: @user.id,
      project_id: @project.id,
      role: 'annotator'
    })

    respond_to do |format|
      if @project_user.save
        format.html { redirect_to project_project_users_path(@project), notice: 'Project user was successfully created.' }
        format.json { render :show, status: :created, location: @project_user }
      else
        format.html { render project_project_users_path(@project), error: 'Cannot add a user' }
        format.json { render json: @project_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project_users/1
  # PATCH/PUT /project_users/1.json
  def update
    @project = @project_user.project
    exit_if_not_manager and return
    respond_to do |format|
      if @project_user.update(project_user_params)
        format.html { redirect_to @project_user, notice: 'Project user was successfully updated.' }
        format.json { render :show, status: :ok, location: @project_user }
      else
        format.html { render :edit }
        format.json { render json: @project_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_users/1
  # DELETE /project_users/1.json
  def destroy
    @project = @project_user.project
    exit_if_not_manager and return
    @project_user.destroy
    respond_to do |format|
      format.html { redirect_to project_project_users_path(@project), notice: 'Project user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_user
      @project_user = ProjectUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_user_params
      params.require(:project_user).permit(:project_id, :user_id, :role)
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
      %w(name email role).include?(params[:sort]) ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
