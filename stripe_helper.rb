module StripeHelper

  # See https://stripe.com/docs/testing for more card numbers:
  CARD_NUMBERS = {
    visa: '4242424242424242',
    mastercard: '5555555555554444'
  }

  def card_number(type)
    CARD_NUMBERS[type]
  end

  def fill_in_with_force(locator, options)
    page.execute_script "$('#{locator}').val('#{options[:with]}');"
  end

  alias_method :fill_in_stripe_field, :fill_in_with_force

end

RSpec.configure do |config|
  config.include StripeHelper, type: :feature
end
