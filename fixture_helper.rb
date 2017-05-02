module FixtureHelper
  def fixture_file_path(filename)
    # fixture_path is set in spec/rails_helper.rb
    "#{fixture_path}/files/#{filename}"
  end
end

RSpec.configure do |config|
  config.include FixtureHelper
end
