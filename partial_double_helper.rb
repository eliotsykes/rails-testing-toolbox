without_partial_double_verification_supported =
  RSpec::Mocks::ExampleMethods.instance_methods.include?(:without_partial_double_verification)

if without_partial_double_verification_supported
  puts "*"*80
  puts "Please delete #{__FILE__},"
  puts "the version of rspec-mocks in use provides its functionality already."
  puts "*"*80
else
  module PartialDoubleHelper
    # This method is being added to rspec-mocks in 3.6.0, this file only necessary for < 3.6.0
    def without_partial_double_verification
      RSpec::Mocks.configuration.verify_partial_doubles = false
      yield
      RSpec::Mocks.configuration.verify_partial_doubles = true
    end
  end

  RSpec.configure do |config|
    config.include PartialDoubleHelper
  end
end
