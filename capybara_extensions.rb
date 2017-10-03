module CapybaraExtensions
  extend RSpec::Matchers::DSL

  matcher :have_link_open_in_new_window do |locator, options={}|
    match do |page|
      link = page.find_link(locator, options)
      link && link[:target] == '_blank'
    end
  end

  # Matcher checks if the original page has been unloaded and replaced with a new page
  # expect { click_link '' }.to replace_page
  # expect { click_button 'Submit' }.not_to replace_page
  #
  # Also available as exit_page:
  # expect { click_link '' }.to exit_page
  # expect { click_button 'Submit' }.not_to exit_page
  #
  # To alter the wait time from Capybara.default_max_wait_time:
  # expect { click_link 'this takes ages' }.to replace_page(wait: 20.seconds)
  matcher :replace_page do |wait: Capybara.default_max_wait_time|
    supports_block_expectations

    match_unless_raises do |interaction|
      # Generate a unique page id:
      page_id = "test-page-id-#{SecureRandom.hex}"

      execute_script <<-JS.strip_heredoc
        window.addEventListener("beforeunload", function(event) {
          // Precaution (may not be necessary) to ensure that during unload
          // the state is not set to undefined. Only want undefined state
          // to be present on the new page.
          window.__test_page_load_state = "before-unloading";
        });
        // Store the load state and the page id as part of
        // the current page:
        window.__test_page_load_state = "loaded";
        document.documentElement.classList.add("#{page_id}");
      JS

      # Execute the block passed to `expect`:
      interaction.call

      is_page_replaced_snippet = <<-JS.strip_heredoc
        window.__test_page_load_state === undefined && !document.documentElement.classList.contains("#{page_id}")
      JS

      # Wait as it may take some time for the page to be replaced.
      RSpec::Wait.wait(wait).for { evaluate_script(is_page_replaced_snippet) }.to eq(true)
    end
  end
  RSpec::Matchers.alias_matcher :exit_page, :replace_page

  def refresh
    url = URI.parse(current_url)
    if url.query.blank?
      url.query = ""
    else
      url.query << "&"
    end
    url.query << "refreshEnforcer=#{rand}"
    visit url.to_s
  end

  # Provide a select() method that will close the select dropdown
  # after selection automatically. This avoids the sporadic test
  # failures that sometimes occur when a feature spec performs
  # these steps:
  #
  # 1. Spec selects option from dropdown
  # 2. Dropdown does not close fast enough after selection and obstructs button
  # 3. Spec tries to click obstructed button
  # 4. Button click fails silently due to the dropdown obstruction
  # 5. Spec fails
  #
  # The above steps aren't reliably reproducible as the dropdown does
  # often close fast enough after selection. It appears to be easier
  # to reproduce on slower environments (e.g. CI env).
  #
  # This fix works by introducing a custom select method to prevent
  # Capybara automatically forwarding select() calls to page.select().
  #
  # Allows us to customize behaviour whilst also calling
  # page.current_scope.select (defined in Capybara::Node::Actions#select)
  # which is responsible for doing the actual selection work.
  def select(value, options={})
    select_then_close(value, options)
  end

  # Selects option from <select> drop down then blurs so drop down is
  # closed. Useful when a drop down obscures an element that needs to be
  # clicked.
  def select_then_close(value, options = {})
    result = page.select(value, options)
    if jsable_driver?
      expect(blur_active_element).to(eq(true), 'Blur & close select element failed')
    end
    result
  end

  private

  def blur_field(locator)
    find_field(locator).send_keys(:tab)
  end

  def blur_active_element
    return unless jsable_driver?

    # Blurring active element is successful if body becomes active
    # element (in Firefox at least)
    blur_active_element_js = "(function() { document.activeElement.blur(); return document.activeElement == document.body; })()"
    blurred = evaluate_script(blur_active_element_js)
  end

  def jsable_driver?
    CapybaraExtensions.jsable_driver?
  end

  def self.jsable_driver?
    Capybara.current_driver != :rack_test
  end

end

RSpec.configure do |config|
  config.include CapybaraExtensions, type: :feature

  # Make have_* matchers available to request specs e.g.:
  # expect(response.body).to have_title 'My Page Title'
  # and model specs (sometimes rely on mail matchers that use
  # have_css etc. in model specs).
  config.include Capybara::RSpecMatchers, type: /request|model/
end
