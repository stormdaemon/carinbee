module ApplicationHelper
  # Helper methods for alerts with icons
  def alert_with_icon(type, message, options = {})
    icon = options[:icon] || default_icon_for_alert_type(type)
    dismissible = options[:dismissible] || false
    heading = options[:heading]
    
    render 'shared/alert_with_icon', 
           type: type, 
           message: message, 
           icon: icon,
           dismissible: dismissible,
           heading: heading
  end

  def success_alert(message, options = {})
    alert_with_icon('success', message, options)
  end

  def danger_alert(message, options = {})
    alert_with_icon('danger', message, options)
  end

  def warning_alert(message, options = {})
    alert_with_icon('warning', message, options)
  end

  def info_alert(message, options = {})
    alert_with_icon('info', message, options)
  end

  # Helper methods for standardized flash messages
  def set_flash_notice(message)
    flash[:notice] = message
  end

  def set_flash_alert(message)
    flash[:alert] = message
  end

  def set_flash_success(message)
    flash[:success] = message
  end

  def set_flash_error(message)
    flash[:error] = message
  end

  def set_flash_warning(message)
    flash[:warning] = message
  end

  def set_flash_info(message)
    flash[:info] = message
  end

  # Helper for displaying star ratings consistently
  def display_star_rating(rating, options = {})
    rating = rating || 0
    show_text = options.fetch(:show_text, true)
    
    html = content_tag(:span, class: "text-warning fs-5") do
      if rating > 0
        ("⭐" * rating) + ("☆" * (5 - rating))
      else
        content_tag(:span, "☆☆☆☆☆", class: "text-muted")
      end
    end
    
    if show_text
      text = if rating > 0
        "(#{rating}/5)"
      else
        "(Pas de note)"
      end
      html += content_tag(:span, text, class: "text-muted ms-2")
    end
    
    html.html_safe
  end

  private

  def default_icon_for_alert_type(type)
    case type.to_s
    when 'success'
      'fa-check-circle'
    when 'danger', 'error'
      'fa-exclamation-triangle'
    when 'warning'
      'fa-exclamation-circle'
    when 'info'
      'fa-info-circle'
    when 'secondary'
      'fa-question-circle'
    else
      'fa-info-circle'
    end
  end
end
