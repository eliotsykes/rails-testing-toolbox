module FactoryGirlHelper
  def strategy_method(evaluator)
    strategy_method =
      evaluator.instance_variable_get(:@build_strategy).class.name.demodulize.downcase

    strategy_method = :build_stubbed if 'stub' == strategy_method

    strategy_method # build, create, or build_stubbed
  end
end

FactoryGirl::SyntaxRunner.send(:include, FactoryGirlHelper)
