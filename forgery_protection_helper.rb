module ForgeryProtectionHelper
  
  def allow_forgery_protection
    original_allow_forgery_protection = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
    yield
  ensure
    ActionController::Base.allow_forgery_protection = original_allow_forgery_protection
  end

end

RSpec.configure do |config|
  config.include ForgeryProtectionHelper, type: /controller|request|feature/
  
  config.around(allow_forgery_protection: true) do |example|
    allow_forgery_protection(&example)
  end
end
