RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers

  config.after(:each) do
    travel_back
  end
end
