module DeviseHelper
  def devise_error_messages!
    return "" if !devise_error_messages? && flash[:recaptcha_error].blank?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }
    messages << content_tag(:li, flash[:recaptcha_error]) if flash[:recaptcha_error].present?

    sentence = I18n.t("errors.messages.not_saved",
                      :count => messages.size,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation" class="ui message negative">
      <div class="header">#{sentence}</div>
      <ul class="list">
        #{messages.join}
      </ul>
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end

end