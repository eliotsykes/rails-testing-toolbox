module FactoryGirlHelper
  # Sample Usage:
  #
  # after(:stub, :build) do |account, evaluator|
  #   strategy_method = strategy_method(evaluator)
  #
  #   # Calls build_stubbed, build, or create on the user factory with given arguments:
  #   account.owner ||= send(strategy_method, :user, :some_user_trait, email: 'foo@example.org')
  # end
  def strategy_method(evaluator)
    strategy_method =
      evaluator.instance_variable_get(:@build_strategy).class.name.demodulize.downcase

    strategy_method = :build_stubbed if 'stub' == strategy_method

    strategy_method # build, create, or build_stubbed
  end
end

FactoryGirl::SyntaxRunner.send(:include, FactoryGirlHelper)
