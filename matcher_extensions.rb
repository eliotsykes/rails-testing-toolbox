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
