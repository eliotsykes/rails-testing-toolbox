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
