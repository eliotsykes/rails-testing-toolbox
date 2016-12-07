module DelayedJobHelper
  def perform_jobs_without_delay
    delay_jobs = Delayed::Worker.delay_jobs
    Delayed::Worker.delay_jobs = false
    yield
  ensure
    Delayed::Worker.delay_jobs = delay_jobs
  end
end

RSpec.configure do |config|
  config.around(:each, type: :feature) do |example|
    perform_jobs_without_delay do
      example.run
    end
  end

  config.include DelayedJobHelper
end
