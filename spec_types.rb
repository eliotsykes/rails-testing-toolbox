# Define custom spec types not provided by rspec-rails
RSpec.configure do |config|
  spec_types = [
    'service',
    'task', # Rake tasks
    'validator'
  ]

  spec_types.each do |spec_type|
    config.define_derived_metadata(file_path: %r{/spec/#{spec_type.pluralize}/}) do |metadata|
      metadata[:type] = spec_type
    end
  end
end
