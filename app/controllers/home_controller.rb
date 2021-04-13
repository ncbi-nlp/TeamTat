class HomeController < ApplicationController
  def index
    @top_menu = "home"
  end

  def sitemap
  end
  
  def about
    @top_menu = "about"
  end
  def proxy
    url = params[:url]
    response = HTTParty.get(url)
    render plain: response
  end

  def stat
    @project_count = Project.execute_sql("SELECT count(*) as cnt FROM projects").first[0]
    @document_count = Document.execute_sql("SELECT count(*) as cnt FROM documents").first[0]
    @user_count = User.execute_sql("SELECT count(*) as cnt FROM users").first[0]
    @task_count = Task.execute_sql("SELECT count(*) as cnt FROM tasks").first[0]
    @assign_count = Assign.execute_sql("SELECT count(*) as cnt FROM assigns").first[0]
    @round_count = Assign.execute_sql("SELECT SUM(round) FROM projects").first[0]
    @annotation_count = Annotation.execute_sql("SELECT count(*) as cnt FROM annotations").first[0]
    @owner_count = Annotation.execute_sql("SELECT count(DISTINCT user_id) as cnt FROM project_users WHERE role=0").first[0]
  end
end
