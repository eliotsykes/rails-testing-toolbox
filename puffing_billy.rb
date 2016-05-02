require 'billy/rspec'

require_relative 'http_record'
require_relative 'puffing_billy_extensions'

# Configure cache to behave as required. See all available options at:
# https://github.com/oesmith/puffing-billy#caching
Billy.configure do |c|
  stripe_urls_with_ignorable_query_string_params = [
    'https://q.stripe.com/',
    'https://api.stripe.com/v1/tokens'
  ]

  c.ignore_params += stripe_urls_with_ignorable_query_string_params

  stripe_html_url_pattern = %r{https://checkout\.stripe\.com(:443)?/v3/\w+\.html\?distinct_id=.+}
  firefox_url_pattern = %r{\.mozilla\.com}
  mixpanel_analytics_url_pattern = %r{api\.mixpanel\.com}

  # merge_cached_responses_whitelist are URI regex patterns for responses
  # that will be merged into a single cached response. Useful for analytics,
  # social buttons with minor URL variations. A response will be recorded
  # once and reused.
  c.merge_cached_responses_whitelist = [
    stripe_html_url_pattern,
    firefox_url_pattern,
    mixpanel_analytics_url_pattern
  ]

  c.cache = true
  c.cache_request_headers = false

  fix_cors_header = proc do |_request, response|
    allowed_origins = response[:headers]['Access-Control-Allow-Origin']
    if allowed_origins.present?
      localhost_port_pattern = %r{(?<=http://127\.0\.0\.1:)(\d+)}
      allowed_origins.sub!(
        localhost_port_pattern, Capybara.current_session.server.port.to_s
      )
    end
  end
  c.after_cache_handles_request = fix_cors_header

  c.persist_cache = true
  c.non_successful_cache_disabled = false
  c.non_successful_error_level = :warn

  # cache_path is where responses from external URLs will be saved as YAML.
  c.cache_path = "spec/support/http_cache/browser/"

  # Avoid having tests dependent on external URLs.
  #
  # To enable recording new responses temporarily, run the individual spec
  # and prepend with RECORD set to true:
  # RECORD=true bin/rspec spec/features/user_upgrades_spec.rb
  c.non_whitelisted_requests_disabled = HttpRecord.off?
end

# VCR configured to ignore HTTP interactions handled by Puffing Billy
if defined?(VCR)
  VCR.configure do |config|
    config.ignore_request { |request| handled_by_billy?(request) }
  end

  def handled_by_billy?(request)
    browser_user_agent?(request) && puffing_billy_driver_active?
  end

  def browser_user_agent?(request)
    user_agent = request.headers["User-Agent"].try(:first)
    /Firefox/ === user_agent
  end

  def puffing_billy_driver_active?
    /_billy\z/ === Capybara.current_driver
  end

end

# Uncomment the *_billy driver for your desired browser:
Capybara.javascript_driver = :selenium_billy # Uses Firefox
# Capybara.javascript_driver = :selenium_chrome_billy
# Capybara.javascript_driver = :webkit_billy
# Capybara.javascript_driver = :poltergeist_billy

module BillyCache
  # Use with_browser_responses('describe interactions here') do ... end
  # in feature spec scenarios.
  def with_browser_responses(scope, &block)
    proxy.cache.with_scope(scope, &block)
  end
end

RSpec.configure do |config|
  config.include BillyCache, type: :feature
end
