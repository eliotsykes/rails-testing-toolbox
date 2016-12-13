module CapybaraExtensions
  extend RSpec::Matchers::DSL

  matcher :have_link_open_in_new_window do |locator, options={}|
    match do |page|
      link = page.find_link(locator, options)
      link && link[:target] == '_blank'
    end
  end

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
    expect(blur_active_element).to(eq(true), 'Blur & close select element failed')
    result
  end

  private

  def blur_active_element
    return unless jsable_driver?

    # Blurring active element is successful if body becomes active
    # element (in Firefox at least)
    blur_active_element_js = "(function() { document.activeElement.blur(); return document.activeElement == document.body; })()"
    blurred = evaluate_script(blur_active_element_js)
  end

  def jsable_driver?
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
