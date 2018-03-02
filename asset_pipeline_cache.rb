# Inspired by https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/2646/diffs

class AssetPipelineCache
  include Singleton

  def initialize
    @primed = false
  end

  def primed?
    @primed = cache_files_exist? unless @primed
    @primed
  end

  def cache_files_exist?
    cache = Rails.root.join(*%w(tmp cache assets test))
    Dir.exist?(cache) && Dir.entries(cache).length > 2
  end

  # When no cached assets exist, manually hit the root path to create them
  #
  # Otherwise they'd be created by the first test, often timing out and
  # causing a test failure.
  def prime
    return if primed?
    puts "----------------------------------------------"
    puts "Priming asset pipeline cache..."
    Capybara.current_session.visit '/'
    puts "...completed priming asset pipeline cache."
    puts "----------------------------------------------"
    @primed = true
  end

  def self.prime
    instance.prime
  end

end

RSpec.configure do |config|

  config.before(:each, type: :feature) do
    AssetPipelineCache.prime
  end

  # Consider simplifying AssetPipelineCache by removing its singleton behaviour
  # and instead use RSpec's when_first_matching_example_defined, e.g.:
  # config.when_first_matching_example_defined(type: :feature) do
  #   AssetPipelineCache.prime
  # end
end
