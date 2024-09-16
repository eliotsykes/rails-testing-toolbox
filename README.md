# Rails Testing Toolbox

> Tools to help Rails developers test

Find something nice, [browse files in the rails-testing-toolbox project root](https://github.com/eliotsykes/rails-testing-toolbox).

# Installation notes

These files are designed to be placed in the `specs/support/` subdirectory.

If you haven't used support files yet, you may want to uncomment the following line in `specs/rails_helper.rb`:

```diff
 # The following line is provided for convenience purposes. It has the downside
 # of increasing the boot-up time by auto-requiring all files in the support
 # directory. Alternatively, in the individual `*_spec.rb` files, manually
 # require only the support files necessary.
 #
-# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }
+Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }
```
