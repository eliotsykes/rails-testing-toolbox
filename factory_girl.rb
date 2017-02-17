RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  skip_factory_girl_lint_for_speed = config.files_to_run.one?

  enable_profiling = config.files_to_run.size > 1
  factory_girl_profile = {} if enable_profiling

  config.before(:suite) do
    # Reload FactoryGirl to avoid ActiveRecord::AssociationTypeMismatch errors with Spring
    # https://github.com/thoughtbot/factory_girl/blob/d42595f4696a986d626a6b84e2592e85c5bb4c4f/GETTING_STARTED.md#rails-preloaders-and-rspec
    FactoryGirl.reload

    if enable_profiling
      ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |name, start, finish, id, payload|
        duration_in_secs = finish - start
        factory_name = payload[:name]
        strategy_name = payload[:strategy]
        factory_girl_profile[factory_name] ||= {}
        factory_girl_profile[factory_name][strategy_name] ||= { duration_in_secs: 0.0, count: 0 }
        factory_girl_profile[factory_name][strategy_name][:duration_in_secs] += duration_in_secs
        factory_girl_profile[factory_name][strategy_name][:count] += 1
      end
    end

    begin
      if skip_factory_girl_lint_for_speed
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

  if enable_profiling
    config.after(:suite) do
      puts "\nFactoryGirl Profiles"
      total_in_secs = 0.0
      factory_girl_profile.each do |factory_name, factory_profile|
        puts "\n  #{factory_name}"
        factory_profile.each do |strategy, profile|
          puts "    #{strategy} called #{profile[:count]} times took #{profile[:duration_in_secs].round(2)} seconds total"
          total_in_secs += profile[:duration_in_secs]
        end
      end
      puts "\n Total FactoryGirl time #{total_in_secs.round(2)} seconds"
    end
  end

end
