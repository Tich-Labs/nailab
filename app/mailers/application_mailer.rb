class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("DEVISE_MAILER_SENDER", "noreply@nailab.app")
  layout "mailer"
end
