# Install gem https://github.com/gocardless/rspec-activejob
require 'rspec/active_job'

module JobHelper
  def perform_next_job
    job = enqueued_jobs.shift
    job_data = {
      'job_class' => job[:job].name,
      'queue_name' => job[:queue],
      'arguments' => job[:args]
    }
    performed_jobs << job
    ActiveJob::Base.execute(job_data)
  end
end

RSpec.configure do |config|
  config.include ActiveJob::TestHelper
  config.include JobHelper

  config.include(RSpec::ActiveJob)

  config.after(:each) do
    ActiveJob::Base.queue_adapter.enqueued_jobs = []
    ActiveJob::Base.queue_adapter.performed_jobs = []
  end
end
