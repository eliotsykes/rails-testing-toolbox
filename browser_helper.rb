module BrowserHelper
  # Use browser_logs to get the captured console.log entries when
  # debugging JavaScript.
  def browser_logs
    page.driver.browser.manage.logs.get('browser').map do |log_entry|
      "[#{Time.at(log_entry.timestamp.to_i)}] [#{log_entry.level}] #{log_entry.message}"
    end.join("\n")
  end
end

RSpec.configure do |config|
  config.include BrowserHelper, type: :feature
end
