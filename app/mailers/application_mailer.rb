class ApplicationMailer < ActionMailer::Base
  default from: Settings.default.mailer.from
  layout "mailer"
end
