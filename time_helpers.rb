module TimeHelpers
  include ActiveSupport::Testing::TimeHelpers

  def freeze_time
    travel_to Time.zone.now
  end
end

RSpec.configure do |config|
  config.include TimeHelpers

  config.after(:each) do
    travel_back
  end
end
