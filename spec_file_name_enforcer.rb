# See https://eliotsykes.com/spec-enforcer
RSpec.configure do |config|
  config.before(:suite) do

    files_without_spec_suffix = Dir.glob('spec/**/*').select do |filename|
      # Customize regular expression patterns below as needed. Common
      # non-spec file paths under spec/ will not raise an error.
      File.file?(filename) &&
        !filename.match(/_spec\.rb\z/) &&
        !filename.match(%r{\Aspec/(support|factories|mailers/previews)/}) &&
        !filename.match(%r{\Aspec/(spec_helper\.rb|rails_helper\.rb|examples\.txt)\z})
    end

    if files_without_spec_suffix.any?
      raise 'Spec files need _spec.rb suffix: ' + files_without_spec_suffix.join(', ')
    end
  end
end
