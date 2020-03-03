module DocumentsHelper
  def _hide_email(email, name_or_email, is_manager)
    if is_manager
      name_or_email
    else
      if email == current_user.email
        "You"
      else
        if @annotators_hidden_names.present?
          @annotators_hidden_names[email] || "Other"
        else
          "Other"
        end
      end
    end
  end

  def hide_email(email, project, current_user)
    if project.manager?(current_user)
      user = User.find_by_email(email)
    end
    _hide_email(email, user.name_and_email, project.manager?(current_user))
  end

  def hide_user(user, project, current_user)
    _hide_email(user.email_or_name, user.name_and_email, project.manager?(current_user))
  end

  def hide_email2(email, project, current_user)
    _hide_email(email, email, project.manager?(current_user))
  end

  def hide_user2(user, project, current_user)
    _hide_email(user.email_or_name, user.email, project.manager?(current_user))
  end

  def infon_helper(infons, cls_name)
    %{
    <div class="ui modal #{cls_name}">
      <i class="close icon"></i>
      <div class="header">
        Infon (#{infons.size})
      </div>
      <div class="content">
        <ul class="ui list body">
          #{infons.map{|k,v| "<li>#{k}: #{v}</li>".html_safe}.join("\n")}
        </ul>
      </div>
    </div>
    }.html_safe
  end
end
