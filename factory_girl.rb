RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.add_setting :skip_factory_lint, default: false
  config.skip_factory_lint = config.files_to_run.one?

  config.before(:suite) do
    # Reload FactoryGirl to avoid ActiveRecord::AssociationTypeMismatch errors with Spring
    # https://github.com/thoughtbot/factory_girl/blob/d42595f4696a986d626a6b84e2592e85c5bb4c4f/GETTING_STARTED.md#rails-preloaders-and-rspec
    FactoryGirl.reload

    begin
      if config.skip_factory_lint?
        puts "Skipping FactoryGirl.lint for speed"
      else
        DatabaseCleaner.start

        start = Time.now

        # Option 1) Lint all factories with traits:
        FactoryGirl.lint traits: true

        # OR Option 2) Lint selected factories (useful for legacy codebases):
        # factories_needing_tlc = [:complex_invoice, :big_product, :scary_address]
        # factories_to_lint = FactoryGirl.factories.reject do |factory|
        #   factories_needing_tlc.include?(factory.name)
        # end
        # FactoryGirl.lint(factories_to_lint, traits: true)

        duration = Time.now - start
        puts "FactoryGirl.lint took #{duration.round(1)} seconds"
      end
    ensure
      DatabaseCleaner.clean
    end
  end

end
