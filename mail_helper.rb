require_relative 'email_spec'

module MailHelper
  def mails_count
    all_emails.size
  end

  def deliver_email(&block)
    perform_enqueued_jobs(only: ActionMailer::DeliveryJob, &block)
  end

  # Add your own methods like last_email_sent_to_admin, last_email_sent_to_support, etc. to
  # improve clarity of tests that call them:
  #
  # def last_email_sent_to_admin
  #   open_last_email_for('admin@your-domain.com')
  # end
end

RSpec.configure do |config|
  config.include MailHelper
end
