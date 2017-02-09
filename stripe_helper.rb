module StripeHelper

  # See https://stripe.com/docs/testing for more card numbers:
  CARD_NUMBERS = {
    visa: '4242424242424242',
    mastercard: '5555555555554444'
  }

  def card_number(type)
    CARD_NUMBERS[type]
  end

  def fill_in_with_force(locator, with:)
    field_id = find_field(locator)[:id]
    page.execute_script "document.getElementById('#{field_id}').value = '#{with}';"
  end

  alias_method :fill_in_stripe_field, :fill_in_with_force

end

RSpec.configure do |config|
  config.include StripeHelper, type: :feature
end
