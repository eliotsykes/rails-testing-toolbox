RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint traits:true
      factories_needing_tlc = []
      factories_to_lint = FactoryGirl.factories.reject do |factory|
        factories_needing_tlc.include?(factory.name)
      end
      FactoryGirl.lint(factories_to_lint, traits: true)
    ensure
      DatabaseCleaner.clean
    end
  end

end
