module PauseHelper
  # Try using pause instead of binding.pry if binding.pry halts execution
  # of the test server so you can't easily debug feature specs by
  # interacting with the app. Alternatively try removing pry-byebug and
  # using only the pry-rails or pry gems in your Gemfile.
  def pause
    $stderr.write 'Press enter to continue'
    $stdin.gets
  end
end

RSpec.configure do
  config.include PauseHelper, type: :feature
end
