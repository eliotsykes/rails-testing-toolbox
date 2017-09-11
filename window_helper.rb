require_relative 'capybara_extensions'

module WindowHelper
  def scroll_to_top
    return unless jsable_driver?

    execute_script "window.scrollTo(0, 0)"
  end

  def scroll_to_bottom
    return unless jsable_driver?

    execute_script "window.scrollTo(0, document.body.scrollHeight)"
  end

  def scroll_to_field(locator)
    return unless jsable_driver?

    field = find_field locator
    element_id = field[:id]
    css_selector = "##{element_id}"
    scroll_to_element css_selector
  end

  def scroll_to_element(css_selector)
    return unless jsable_driver?

    execute_script <<-JS
      (function() {
        var element = $('#{css_selector}');
        var elementScrollOffset = element.offset().top;
        var fixedNavHeightAllowance = $('.navbar-fixed-top').outerHeight() || 0;
        var totalScrollOffset = elementScrollOffset - fixedNavHeightAllowance;
        window.scrollTo(0, totalScrollOffset);
      })();
    JS
  end

  def maximize_window
    return unless jsable_driver?

    available_width, available_height = execute_script <<-JS
      if (window.screen) {
        return [window.screen.availWidth, window.screen.availHeight];
      }
      return [0, 0];
    JS

    return if available_width == 0 || available_height == 0

    current_window.resize_to(available_width, available_height)
  end
end

RSpec.configure do |config|
  config.include WindowHelper, type: :feature
end
