RSpec.configure do |config|
  config.before(:each, type: /mailer|request/) do
    StripeMock.start
  end

  config.after(:each, type: /mailer|request/) do
    StripeMock.stop
  end
end
