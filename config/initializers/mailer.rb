if Rails.env.production?
  config_path = File.expand_path(Rails.root.to_s + '/config/mailer.yml')
  if File.exists? config_path
    ENV.update YAML.load_file(config_path)[Rails.env]
  end

  ActionMailer::Base.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: 587,
    from: 'brimir@mesbesoinsmoto.com',
    domain: 'mesbesoinsmoto.com',
    user_name: 'brimir@mesbesoinsmoto.com',
    password: 'bQG-c5y-3Vs-U7J',
    authentication: :login,
    enable_starttls_auto: true
  }
end