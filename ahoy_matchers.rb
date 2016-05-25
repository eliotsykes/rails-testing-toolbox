require_relative 'matcher_extensions'

RSpec::Matchers.define :have_tracked_event do |name, user: nil, **props|
  match_unless_raises do |_|
    relation = Ahoy::Event.where(name: name, user_id: user.try(:id))
    props.each do |key, value|
      relation = relation.where("properties ->> ? = ?", key, value)
    end
    RSpec::Wait.wait_for { relation.exists? }.to eq true
  end
end
