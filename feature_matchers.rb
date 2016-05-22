require_relative 'matcher_extensions'

module FeatureMatchers
  extend RSpec::Matchers::DSL

  # Example matchers
  # matcher :be_join_page do
  #   match_unless_raises do |page|
  #     expect(page).to have_current_path '/join'
  #     expect(page).to have_button 'Subscribe'
  #   end
  # end
  #
  # matcher :be_subscription_requested_page do
  #   match_unless_raises do |page|
  #     expect(page).to have_content 'Almost done! Check your email and click the confirmation link.'
  #   end
  # end

  matcher :have_flash do |level, text|
    match_unless_raises do |page|
      expect(page).to have_css("[data-flash=#{level}]", text: text)
    end
  end
end

RSpec.configure do |config|
  config.include FeatureMatchers, type: :feature
end
