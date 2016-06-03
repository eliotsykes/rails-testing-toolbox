# See: https://github.com/thoughtbot/paperclip#testing
# Assumes default paperclip config for :filesystem storage in test env.
RSpec.configure do |config|
  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/public/system/"])
  end
end
