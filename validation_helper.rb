module ValidationHelper
  # Forces the given object to never be valid.
  def never_valid(obj)
    obj.singleton_class.validate { errors.add(:base, 'Never valid') }
  end
end

RSpec.configure do |config|
  config.include ValidationHelper
end
