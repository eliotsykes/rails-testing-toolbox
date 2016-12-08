Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :selenium_chrome_ssl do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(accept_ssl_certs: true)
  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

def print_chromedriver_help_if_needed(exception)
  return if exception.nil?

  chromedriver_needs_installing =
    exception.is_a?(Selenium::WebDriver::Error::WebDriverError) &&
    /chromedriver/i === exception.message

  return unless chromedriver_needs_installing

  puts '-'*80
  puts 'chromedriver is not installed, please install to run JS-dependent specs:'
  puts '  - On macOS `brew install chromedriver`'
  puts '-'*80
end

RSpec.configure do |config|
  config.around(:each, type: :feature) do |example|
    example.run
    print_chromedriver_help_if_needed(example.exception)
  end
end
