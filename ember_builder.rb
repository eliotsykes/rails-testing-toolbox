require_relative 'browser_cache'

class EmberBuilder
  include Singleton

  def initialize
    @build_count = 0
  end

  def build_once
    build if @build_count == 0
  end

  def build
    puts "----------------------------------------------"
    puts "Building Ember test environment..."
    system "bin/ember build --environment=test"
    puts "...completed building Ember test environment"
    puts "----------------------------------------------"
    @build_count += 1
  end

  def self.build_once
    instance.build_once
  end

end

RSpec.configure do |config|

  config.before(:each, type: :feature) do
    EmberBuilder.build_once
    # Increase default wait time to account for Ember app boot time:
    using_wait_time 20.seconds do
      # Use one of BrowserCache or AssetPipelineCache
      # AssetPipelineCache.prime
      BrowserCache.prime
    end
  end

  # Consider simplifying EmberBuilder and BrowserCache by removing their singleton behaviour
  # and instead use RSpec's when_first_matching_example_defined, e.g.:
  # config.when_first_matching_example_defined(type: :feature) do
  #   EmberBuilder.build
  #   using_wait_time(20.seconds) { BrowserCache.prime }
  # end

end
