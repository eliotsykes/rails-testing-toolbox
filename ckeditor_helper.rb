module CkeditorHelper
  def fill_in_editor_field(text)
    iframe = find('iframe.cke_wysiwyg_frame')
    within_frame(iframe) do
      find('body[contenteditable]').set(text)
    end
  end
end

RSpec.configure do |config|
  config.include CkeditorHelper, type: :feature
end
