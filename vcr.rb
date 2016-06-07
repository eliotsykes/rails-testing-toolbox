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
    update_content_length_header: true,
    record: record_mode
  }

  # Temporarily enable config.debug_logger when debugging VCR:
  # config.debug_logger = File.open(Rails.root.join('log', 'vcr.log'), 'w')
  # config.debug_logger = STDOUT

  config.cassette_library_dir = "spec/support/http_cache/server"
  config.hook_into :webmock

  # Only want VCR to intercept requests to external URLs.
  config.ignore_localhost = true

  config.allow_http_connections_when_no_cassette = false

  # Replace sensitive data before recording cassette
  config.before_record do |http_interaction|
    sensitive_request_headers = ['Authorization']
    sensitive_request_headers.each do |header_key|
      if http_interaction.request.headers.key?(header_key)
        raise "Handle protecting #{header_key} request header in VCR"
      end
    end

    sensitive_response_headers = ['Set-Cookie']
    sensitive_response_headers.each do |header_key|
      if http_interaction.response.headers.key?(header_key)
        raise "Handle protecting #{header_key} response header in VCR"
      end
    end

    def replace_uri_credentials(http_interaction)
      dummy_credentials_by_host_pattern = {
        /example\.com/ => 'EXAMPLE_USER_FOR_TEST:EXAMPLE_SECRET_FOR_TEST',
        /foo\.com/ => 'FOO_USER_FOR_TEST:FOO_SECRET_FOR_TEST'
      }

      http_interaction.request.uri.sub!(%r{(?<=://).*:.*(?=@)}) do
        host_and_path = $'
        result = dummy_credentials_by_host_pattern.find do |(host_pattern, credentials)|
          host_pattern === host_and_path
        end
        raise "Not yet able to handle dummy credentials for #{host_and_path}" if result.blank?
        dummy_credentials = result.last
      end
    end

    replace_uri_credentials(http_interaction)
  end
end
