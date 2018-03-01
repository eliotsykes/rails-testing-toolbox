# Should be used with CapybaraInterceptor, see capybara_interceptor.rb in this directory.
#
# Gives access to last_session, last_env in feature specs. Handy for debugging intermittent
# failures. Reading last_session, last_env etc. in a feature spec isn't usually needed however,
# so consider aiming for minimal usage of this.
module LastEnv

  def self.current=(env)
    @current = env
  end

  def self.current
    @current
  end

  def last_env
    LastEnv.current
  end

  def last_session
    # Or last_controller&.session
    last_env['rack.session']
  end

  def last_request
    last_controller&.request
  end

  def last_response
    last_controller&.response
  end

  def last_controller
    last_env['action_controller.instance']
  end
end

RSpec.configure do |config|
  config.include LastEnv, type: :feature
end
