# Consider simplifying BrowserCache by removing its singleton behaviour
# and instead use RSpec's when_first_matching_example_defined.
class BrowserCache
  include Singleton

  def initialize
    @primed_drivers = []
  end

  def prime
    return if @primed_drivers.include?(Capybara.current_driver)
    puts "----------------------------------------------"
    puts "Priming browser cache for #{Capybara.current_driver} driver..."
    Capybara.current_session.visit '/'
    puts "...completed priming browser cache."
    puts "----------------------------------------------"
    @primed_drivers << Capybara.current_driver
  end

  def self.prime
    instance.prime
  end

end
