require 'simplecov'
require 'coveralls'

if Coveralls.should_run?
  Coveralls.wear!
else
  SimpleCov.start
end

