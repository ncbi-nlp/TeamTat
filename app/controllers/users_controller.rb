class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :new, :edit, :create, :update]
  before_action :set_top_menu
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction

  # GET /users
  # GET /users.json
  def index
    if !current_user.super_admin?
      return redirect_back fallback_location: root_path, alert: 'Not authorized.'
    end

    @users = User
    if params[:term].present?
      @users = @users.where("email like ? or name like ? ", "%#{params[:term]}%", "%#{params[:term]}%")
    end

    if params[:email].present?
      @users = @users.where("email = ?", params[:email])
    end

    if request.format.json?
      if params[:project_id].present?
        assigned = ProjectUser.where('project_id=?', params[:project_id]).all
        ids = assigned.map{|pu| pu.user_id}
        @users = @users.where("id NOT IN (?)", ids)
      end
      @users = @users.where('email NOT LIKE ?', "%@not-exist.email%")
      @users = @users.order("email asc")
    else
      @users = @users.order(sort_column + " " + sort_direction).page params[:page]
    end
    respond_to do |format|
      format.html
      format.json {render json:@users.as_json(only: [:id, :email, :name])}
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    # semantic_breadcrumb :Account
    # if !current_user.super_admin? && @user.id != current_user.id
    #   return redirect_back fallback_location: root_path, alert: 'Not authorized.'
    # end

    if @user.session_str.present?
      @url = "#{request.protocol}#{request.host_with_port}/sessions/" + @user.session_str
    end
  end

  # GET /users/new
  def new
    if !current_user.super_admin?
      return redirect_back fallback_location: root_path, alert: 'Not authorized.'
    end
    @user = User.new
    # redirect_to current_user
  end

  def create
    if !current_user.super_admin?
      return redirect_back fallback_location: root_path, alert: 'Not authorized.'
    end
    
    @user = User.new(user_params)  
    @user.skip_password_validation = true
    @user.generate_random_ui_avatar if @user.image.blank?
    respond_to do |format|:trackable 
      if @user.save
        format.html { redirect_to users_path, notice: 'The user was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  # GET /users/1/edit
  def edit
    if !current_user.super_admin? && @user.id != current_user.id
      return redirect_back fallback_location: root_path, alert: 'Not authorized.'
    end

    unless @user.valid_email?
      @user.email = ""
    end
  end

  def generate
    if verify_recaptcha
      current_user = User.new_anonymous_user
      current_user.save
      logger.debug(current_user.errors.inspect)
      cookies[:teamtat] = {
        value: current_user.session_str,
        expires: 10.year.from_now
      }
      sign_in(current_user)
      redirect_to "/", notice: 'Session was successfully started.'
    else
      redirect_to new_user_session_url, alert: 'Please verify reCAPTCHA.'
    end 
  end

  def sessions
    logger.debug("ASK_NEW_SESSION #{@ask_new_session}., CURRENT_USER #{current_user}")
    if @ask_new_session && current_user.present?
      if current_user.session_str.present?
        @url = "#{request.protocol}#{request.host_with_port}/sessions/" + current_user.session_str
      end
      
      @user = current_user
      render :show
    else
      redirect_to "/", alert: "Session does not exist: '#{params[:session_str]}'"
    end
  end

  def sendmail
    session_str = params[:session_str] || current_user.session_str
    path = "/sessions/#{session_str}"
    return_path = params[:return_path] || path
    UserMailer.session_email(params[:email], current_user, request.base_url + path).deliver_later
    redirect_to return_path, notice: "Email was successfully sent."
  end

  # POST /users
  # POST /users.json
  # def create
  #   @user = User.new(user_params)
  #   return
  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to @user, notice: 'User was successfully created.' }
  #       format.json { render :show, status: :created, location: @user }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if !current_user.super_admin? && @user.id != current_user.id
      return redirect_back fallback_location: root_path, alert: 'Not authorized.'
    end

    if params[:user][:password] != params[:user][:password_confirmation]
      return redirect_back fallback_location: root_path, alert: "Password confirmation doesn't match Password"
    end

    params[:user].delete(:name) if params[:user][:name].blank?
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:super_admin) unless current_user.super_admin?

    logger.debug(params[:user])
    respond_to do |format|
      if @user.update(user_params)
        @user.generate_random_ui_avatar if @user.image.blank? || @user.image.include?("https://ui-avatars.com/api/?name=")
        bypass_sign_in(@user) unless current_user.super_admin? 
        format.html { 
          if current_user.super_admin? 
            redirect_to users_path, notice: 'User profile was successfully updated.' 
          else
            redirect_to @user, notice: 'User profile was successfully updated.' 
          end
          }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if !current_user.super_admin? && @user.id != current_user.id
      return redirect_back fallback_location: root_path, alert: 'Not authorized.'
    end

    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully removed.' }
      format.json { head :no_content }
    end
  end

  def become
    return if !current_user.super_admin? && session[:return_super_user].blank?
    if session[:return_super_user].blank?
      session[:return_super_user] = become_user_path(current_user)
    else
      session.delete(:return_super_user)
    end
    cookies.delete(:teamtat)
    request.env['warden'].request.env['devise.skip_trackable'] = '1'
    sign_in(:user, User.find(params[:id]))
    redirect_to root_url # or user_root_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :super_admin, :name)
    end

    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

    def set_top_menu
      @top_menu = 'admin'
    end

    
end
