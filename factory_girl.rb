RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.start

      # Option 1) Lint all factories with traits:
      FactoryGirl.lint traits: true

      # OR Option 2) Lint selected factories (useful for legacy codebases):
      # factories_needing_tlc = [] # List factories that aren't working yet
      # factories_to_lint = FactoryGirl.factories.reject do |factory|
      #   factories_needing_tlc.include?(factory.name)
      # end
      # FactoryGirl.lint(factories_to_lint, traits: true)
    ensure
      DatabaseCleaner.clean
    end
  end

end
