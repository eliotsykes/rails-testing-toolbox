# Annotate specs with metadata:
# - 'run_jobs: true' to run jobs inline immediately
# - 'run_jobs: false' to store jobs in delayed_jobs table, and *not* run the jobs
module DelayedJobHelper

  DELAY_IF_JOB_SCHEDULED_IN_FUTURE = ->(job) { job.run_at.try(:future?) }
  DELAY_ALL_JOBS = true

  def run_jobs(perform)
    original_delay_jobs = Delayed::Worker.delay_jobs

    if perform
      Delayed::Worker.delay_jobs = DELAY_IF_JOB_SCHEDULED_IN_FUTURE
    else
      Delayed::Worker.delay_jobs = DELAY_ALL_JOBS
    end

    yield
  ensure
    Delayed::Worker.delay_jobs = original_delay_jobs
  end

  def run_next_job(allow_failure: false)
    num_jobs_to_run = 1
    success_count, failure_count = Delayed::Worker.new.work_off(num_jobs_to_run)
    expect(success_count + failure_count).to eq(1), 'should have tried to perform one job'

    if !allow_failure
      expect(success_count).to eq(1), 'job should have run successfully'
      expect(failure_count).to eq(0), 'unexpected job failure'
    end
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
