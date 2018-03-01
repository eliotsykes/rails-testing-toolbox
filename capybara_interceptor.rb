require_relative 'last_env'

# Captures a reference to env for use in feature specs (typically for debugging flakey tests).
# Call last_env/last_session in feature specs.
module CapybaraInterceptor

  def call(env)
    result = super(env)
    # Note this will capture all envs, even those for asset requests.
    # Consider only capturing "interesting" envs, perhaps if they have
    # env['action_controller.instance'] set, otherwise skip.
    LastEnv.current = env
    result
  end

end

Capybara::Server::Middleware.prepend(CapybaraInterceptor)
