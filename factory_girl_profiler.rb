class FactoryGirlProfiler

  attr_accessor :results

  def self.setup
    profiler = self.new

    RSpec.configure do |config|
      config.before(:suite) { profiler.subscribe }
      config.after(:suite) { profiler.dump }
    end
  end

  def initialize
    self.results = {}
  end

  def subscribe
    ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |name, start, finish, id, payload|
      factory, strategy = payload.values_at(:name, :strategy)

      factory_result = results[factory] ||= {}
      strategy_result = factory_result[strategy] ||= { duration_in_secs: 0.0, count: 0 }

      duration_in_secs = finish - start
      strategy_result[:duration_in_secs] += duration_in_secs
      strategy_result[:count] += 1
    end
  end

  def dump
    puts "\nFactoryGirl Profiles"
    total_in_secs = 0.0
    results.each do |factory_name, factory_profile|
      puts "\n  #{factory_name}"
      factory_profile.each do |strategy, profile|
        puts "    #{strategy} called #{profile[:count]} times took #{profile[:duration_in_secs].round(2)} seconds total"
        total_in_secs += profile[:duration_in_secs]
      end
    end
    puts "\n Total FactoryGirl time #{total_in_secs.round(2)} seconds"
  end

end

RSpec.configure do |config|
  config.add_setting :profile_factories, default: false
  config.profile_factories = config.profile_examples? || ARGV.include?('--profile') || ARGV.include?('-p')
  FactoryGirlProfiler.setup if config.profile_factories?
end
