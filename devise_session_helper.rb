require_relative 'capybara_extensions'

module DeviseSessionHelper
  def sign_in(user, scope: :user, login_param: :email)
    session_path = send("#{scope}_session_path")
    post_via_redirect(session_path,
      "#{scope}[#{login_param}]" => user.email,
      "#{scope}[password]" => user.password
    )
    expect(response.body).to have_text 'Signed in successfully'
  end
end

RSpec.configure do |config|
  config.include DeviseSessionHelper, type: :request
end
