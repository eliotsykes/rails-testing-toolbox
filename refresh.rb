module Refresh
    def refresh
      url = URI.parse(current_url)
      if url.query.blank?
        url.query = ""
      else
        url.query << "&"
      end
      url.query << "refreshEnforcer=#{rand}"
      visit url.to_s
    end
end

RSpec.configure do |config|
  config.include Refresh, type: :feature
end
