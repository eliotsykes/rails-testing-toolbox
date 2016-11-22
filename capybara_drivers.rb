Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :selenium_chrome_ssl do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(accept_ssl_certs: true)
  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end
