class UserMailer < ApplicationMailer
  default from: 'notifications@teamtat.org'
 
  def project_done
    @project = params[:project]
    @manager = @project.project_users.where('role = 0').first.user
    @url = "https://www.teamtat.org/projects/#{@project.id}"
    if @manager.valid_email?
      mail(to: @manager.email, subject: "Assignments are done for Project #{@project.name}")
      Rails.logger.debug("MAIL TO #{@manager.email} ABOUT #{@project.name}")
    end
  end

  def session_email(email, user, url)
    @user = user
    @url = url
    mail(to: email, subject: "Session: #{user.session_str}")
  end
end