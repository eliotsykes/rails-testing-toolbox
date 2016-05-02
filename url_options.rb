# Sets default_url_options for URL generating model specs
RSpec.configure do |config|
  config.around(:each) do |example|
    begin
      original_default_url_options =  Rails.application.routes.default_url_options
      Rails.application.routes.default_url_options = {host: 'www.example.org', protocol: 'https'}
      example.run
    ensure
      Rails.application.routes.default_url_options = original_default_url_options
    end
  end
end
