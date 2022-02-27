ActionMailer::Base.smtp_settings = {
  user_name: Rails.application.credentials[Rails.env.to_sym][:sendgrid][:user_name],
  password: Rails.application.credentials[Rails.env.to_sym][:sendgrid][:password],
  domain: 'http://194.67.119.77',
  address: 'smtp.sendgrid.net',
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}
