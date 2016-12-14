# Override default capybara webrick server to write to a log file,
# to capture server errors that would be lost otherwise.
Capybara.register_server :webrick do |app, port, host|
  require 'rack/handler/webrick'
  log_path = Rails.root.join("./log/capybara_test_server.log").to_s
  Rack::Handler::WEBrick.run(app,
    Host: host,
    Port: port,
    AccessLog: [],
    Logger: WEBrick::Log::new(log_path)
  )
end
