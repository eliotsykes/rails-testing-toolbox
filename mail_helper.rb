module MailHelper
  def deliver_email(&block)
    perform_enqueued_jobs(only: ActionMailer::DeliveryJob, &block)
  end
end

RSpec.configure do |config|
  config.include MailHelper
end
