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

  # Protect sensitive data from being captured in cassette
  config.filter_sensitive_data('<A_SECRET>') { ENV.fetch('A_SECRET') }
  protected_authorization_headers = ['Bearer <A_SECRET>']

  config.filter_sensitive_data('<FOO_USER>') { ENV.fetch('FOO_USER') }
  config.filter_sensitive_data('<FOO_SECRET>') { ENV.fetch('FOO_SECRET') }
  protected_uri_credentials = ['<FOO_USER>:<FOO_SECRET>']

  # Flag unprotected sensitive data
  config.before_record do |http_interaction|
    authorization_header =  http_interaction.request.headers['Authorization']
    if authorization_header
      raise 'Unexpected number of Authorization headers' if authorization_header.size != 1

      unless protected_authorization_headers.include?(authorization_header[0])
        raise 'Found Authorization header unprotected by VCRs filter_sensitive_data'
      end
    end

    sensitive_response_headers = ['Set-Cookie']
    sensitive_response_headers.each do |header_key|
      if http_interaction.response.headers.key?(header_key)
        raise "Handle protecting #{header_key} response header in VCR"
      end
    end

    flag_uri_credentials(http_interaction, protected_uri_credentials)
  end

  def flag_uri_credentials(http_interaction, protected_uri_credentials)
    uri_credentials_pattern = %r{(?<=://)(?<credentials>.*:.*)(?=@)}
    http_interaction.request.uri.match(uri_credentials_pattern) do |match_data|
      if !match_data[:credentials].in?(protected_uri_credentials)
        raise 'Unprotected credentials found, protect with VCR config'
      end
    end
  end
end
