require_relative 'capybara_extensions'

module HaveCssInViewport
  extend RSpec::Matchers::DSL

  # Tests that the element is visible AND in the viewport of the browser (i.e. the user can see the
  # element without scrolling when it is in the viewport). Skips the viewport check if the browser
  # is not javascript-capable.
  matcher :have_css_in_viewport do |css_selector, wait: Capybara.default_max_wait_time|
    match do |page|
      is_visible = page.has_css?(css_selector, visible: true)

      return false if !is_visible

      return is_visible if !CapybaraExtensions.jsable_driver?

      is_in_viewport_snippet = <<-JS.strip_heredoc
        (function() {
          var isInViewport = function(element) {
            var rect = element.getBoundingClientRect();
            return (
              rect.top >= 0 &&
              rect.left >= 0 &&
              rect.bottom <= window.innerHeight &&
              rect.right <= window.innerWidth
            );
          };

          var element = document.querySelector('#{css_selector}');
          return isInViewport(element);
        })();
      JS

      # Wait as it may take some time for the element to appear in the
      # viewport (e.g. due to animated scrolling). This will timeout and raise
      # RSpec::Expectations::ExpectationNotMetError if it fails for long enough.
      RSpec::Wait.wait(wait).for { page.evaluate_script(is_in_viewport_snippet) }.to eq(true)

      true
    end
  end
end

RSpec.configure do |config|
  config.include HaveCssInViewport, type: :feature
end
