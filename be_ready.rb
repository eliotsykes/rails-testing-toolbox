module BeReady
  extend RSpec::Matchers::DSL

  # Tests that the page is ready. Always passes if the browser is not javascript-capable. Useful
  # when a page loads images that can change the layout and cause selenium flakiness when clicks
  # miss targets as the page jumps around. If this is the case, use the be_ready matcher to ensure
  # all images on the page are loaded before interacting with the page.
  matcher :be_ready do |wait: Capybara.default_max_wait_time|
    match do |page|
      return true unless CapybaraExtensions.jsable_driver?

      is_ready_snippet = "document.readyState === 'complete'"

      RSpec::Wait.wait(wait).for { page.evaluate_script(is_ready_snippet) }.to eq(true)

      true
    end
  end
end


RSpec.configure do |config|
  config.include BeReady, type: :feature
end
