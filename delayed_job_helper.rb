# Annotate specs with metadata:
# - 'run_jobs: true' to run jobs inline immediately
# - 'run_jobs: false' to store jobs in delayed_jobs table, and *not* run the jobs
module DelayedJobHelper
  def run_jobs(perform)
    original_delay_jobs = Delayed::Worker.delay_jobs
    Delayed::Worker.delay_jobs = !perform
    yield
  ensure
    Delayed::Worker.delay_jobs = original_delay_jobs
  end
end

RSpec.configure do |config|
  config.around(:each) do |example|
    perform = example.metadata.fetch(:run_jobs, true)
    run_jobs(perform) do
      example.run
    end
  end

  config.include DelayedJobHelper
end
