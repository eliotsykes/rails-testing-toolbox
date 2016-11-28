require_relative 'matcher_extensions'

# Reminder: Relax or disable Ahoy's throttling in your test environment
# to avoid events being rejected. See Ahoy README section on throttling
# and/or Ahoy.throttle_limit/period settings.
RSpec::Matchers.define :have_tracked_event do |name, user: nil, **props|

  supports_block_expectations

  match_unless_raises do |interaction|
    is_ahoy_ready_snippet = "typeof ahoy !== 'undefined' && ahoy !== null;"
    RSpec::Wait.wait_for { evaluate_script(is_ahoy_ready_snippet) }.to eq true

    interaction.call

    relation = Ahoy::Event.where(name: name, user_id: user.try(:id))
    props.each do |key, value|
      relation = relation.where("properties ->> ? = ?", key, value)
    end

    RSpec::Wait.wait_for { relation.exists? }.to eq true
  end
end
