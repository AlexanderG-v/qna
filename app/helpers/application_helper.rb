module ApplicationHelper
  CONTEXTUAL_ALERT_CSS_CLASS = {
    notice: 'alert alert-info',
    alert: 'alert alert-danger',
    succes: 'alert alert-success'
  }.freeze

  def flash_class(key)
    CONTEXTUAL_ALERT_CSS_CLASS[key.to_sym]
  end
end
