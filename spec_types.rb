RSpec.configure do |config|
  # Define custom spec types not provided by rspec-rails:
  config.define_derived_metadata(:file_path => %r{/spec/validators/}) do |metadata|
    metadata[:type] = :validator
  end

  # Rake tasks
  config.define_derived_metadata(:file_path => %r{/spec/tasks/}) do |metadata|
    metadata[:type] = :task
  end
end
