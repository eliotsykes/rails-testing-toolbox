require 'active_support/testing/stream'

RSpec.configure do |config|
  # Provides access to methods to silence or capture STDOUT, STDERR: #silence_stream, #quietly, #capture
  config.include ActiveSupport::Testing::Stream
end
