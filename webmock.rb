require 'webmock/rspec'

require_relative 'http_record'

WebMock.disable_net_connect!(allow_localhost: true) if HttpRecord.off?
