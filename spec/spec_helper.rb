require_relative File.join('..', 'lib', 'concourse')
require 'pry'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each) do
    `docker rm -f $(docker ps -a | grep concourse- | cut -d " " -f 1) 2>&1`
  end
end
