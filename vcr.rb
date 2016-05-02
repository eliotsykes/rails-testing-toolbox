require_relative 'webmock'

VCR.configure do |config|
  # To enable recording new responses temporarily, run the individual spec
  # and prepend with RECORD set to true:
  # RECORD=true bin/rspec spec/features/user_upgrades_spec.rb
  record_mode = HttpRecord.on? ? :once : :none
  config.default_cassette_options = {
    decode_compressed_response: true,
    allow_unused_http_interactions: false,
    match_requests_on: [:method, :uri, :body],
    record: record_mode
  }
  config.cassette_library_dir = "spec/support/http_cache/server"
  config.hook_into :webmock

  # Only want VCR to intercept requests to external URLs.
  config.ignore_localhost = true

  config.allow_http_connections_when_no_cassette = false

  # Temporarily enable config.debug_logger when debugging VCR:
  config.debug_logger = File.open(Rails.root.join('log', 'vcr.log'), 'w')
end
