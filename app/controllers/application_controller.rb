class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: -> { request.format.json? || request.format.xml? }
  before_action :check_user  

  def after_sign_in_path_for(resource)
    "/"
  end
  def breadcrumb_for_projects(project = nil)
    if project.present?
      title = "Projects"
      if project.available?(current_user)
        semantic_breadcrumb title, projects_path
      else
        semantic_breadcrumb title, user_projects_path(project.user)
      end
    end
  end

  def exit_if_not_member
    if @project.present? && !@project.available?(current_user)
      respond_to do |format|
        format.html { redirect_back fallback_location: projects_path, alert: "Cannot access the project"}
        format.json { render json: 'Cannot access the project', status: 401 }
      end    
      return true
    end
  end

  def exit_if_not_manager
    if @project.present? && !@project.manager?(current_user)
      respond_to do |format|
        format.html { redirect_back fallback_location: projects_path, alert: "Availble only for the manager of the project"}
        format.json { render json: 'Availble only for the manager of the project', status: 401 }
      end    
      return true
    end
  end

  def exit_if_project_locked
    if @project.locked
      respond_to do |format|
        format.html { redirect_back fallback_location: projects_path, alert: "Project is already locked"}
        format.json { render json: 'Project is already locked' , status: 422 }
      end
      return true
    end
  end

  def exit_if_project_unlocked
    if !@project.locked
      respond_to do |format|
        format.html { redirect_back fallback_location: projects_path, alert: "Project is unlocked"}
        format.json { render json: 'Project is locked' , status: 422 }
      end
      return true
    end
  end

  def check_user
    @params_key = params[:key] || request.headers['x-api-key']
    if (request.format.json? || request.format.xml?) && (!user_signed_in? || @params_key.present?)
      key = ApiKey.where("`key`=?", @params_key).first if @params_key.present?
      if key.present?
        key.access_count = (key.access_count || 0) + 1
        key.last_access_ip = request.remote_ip
        key.last_access_at = Time.now.utc
        key.save
        current_user = key.user
        sign_in(key.user)
      else
        respond_to do |format|
          format.json { render :json => {error: 'Access Denied'}, :status => 401 }
          format.xml { render :json => {error: 'Access Denied'}, :status => 401 }
        end
        return false
      end
    else
      @session_str = params[:session_str] || cookies[:teamtat]
      if params[:session_str].present?
        current_user = User.where("session_str = ?", @session_str).first
        @ask_new_session = true
      else
        current_user = current_user || User.where("session_str = ?", @session_str).first unless @session_str.nil?
      end

      if current_user.blank? && @session_str.present?
        current_user = nil
        cookies.delete :teamtat
        @ask_new_session = true
      end

      if current_user.present? && current_user.session_str.present?
        cookies[:teamtat] = {
          value: current_user.session_str,
          expires: 10.year.from_now
        }
        sign_in(current_user)
      end
    end
  end


end
