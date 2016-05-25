require 'capybara/rails'
require 'capybara/rspec'

# Capybara defaults to 2 secs, increase on CI env to reduce false
# negative failures.
if ENV['CONTINUOUS_INTEGRATION'] || ENV['CI']
  Capybara.default_max_wait_time = 3.seconds
  puts "[Capybara] Using #{Capybara.default_max_wait_time} seconds max wait time"
end
