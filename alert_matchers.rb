module AlertMatchers
  extend RSpec::Matchers::DSL

  # Usage for popup_alert:
  #
  # expect { visit url_for_page_undergoing_attempted_xss_attack }
  #   .not_to popup_alert, 'XSS defenses should prevent alert popup'
  matcher :popup_alert do
    supports_block_expectations

    match do |interaction|
      is_alert_open = true
      interaction.call
      begin
        page.driver.browser.switch_to.alert
      rescue Selenium::WebDriver::Error::NoAlertPresentError
        is_alert_open = false
      end
      is_alert_open
    end
  end
end

RSpec.configure do |config|
  config.include AlertMatchers, type: :feature
end
