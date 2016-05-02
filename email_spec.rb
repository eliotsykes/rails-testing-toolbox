require 'email_spec'

RSpec.configure do |config|
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers

  config.before(:each) do
    reset_mailer # Clears out ActionMailer::Base.deliveries
  end

end
