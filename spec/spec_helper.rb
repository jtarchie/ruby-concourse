require_relative File.join('..', 'lib', 'concourse')
require 'pry'

Excon.defaults[:ssl_verify_peer] = false

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each) do
    Docker::Container.all(all: true).each do |container|
      if container.json['Name'] =~ /concourse-task/
        container.stop!
        container.delete(force: true)
      end
    end
  end
end
