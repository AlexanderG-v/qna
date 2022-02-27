ActionMailer::Base.smtp_settings = {
  user_name: 'apikey',
  password: Rails.application.credentials[Rails.env.to_sym][:sendgrid][:api_key],
  domain: 'http://194.67.119.77',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}
