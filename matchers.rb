# Custom matchers failure message is rescued_exception.message
# when available. Sample usage to get this behaviour, just define a
# matcher as normal, e.g.:
#
# matcher :be_join_page do
#   match_unless_raises do |page|
#     expect(page).to have_current_path '/join'
#     expect(page).to have_button 'Subscribe'
#   end
# end
#
# (nb. match_unless_raises sets rescued_exception)

module ExceptionFailureMessage
  def failure_message
    rescued_exception ? rescued_exception.message : super
  end
end
RSpec::Matchers::DSL::Matcher.include ExceptionFailureMessage

Dir[Rails.root.join("spec/matchers/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include Matchers
end

# Write custom matcher classes in spec/matchers/ directory
# Each matcher class will need to be in a module called
# `Matchers` to work with the RSpec configuration specified.
