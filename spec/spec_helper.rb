require_relative '../lib/re-raise'

RSpec.configure do |config|
  config.default_formatter = 'doc'

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect

    mocks.verify_partial_doubles = true
  end
end
