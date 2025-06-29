# frozen_string_literal: true

require 'simplecov'
SimpleCov.start do
  enable_coverage :branch

  add_filter '/spec/'
  add_filter '/bin/'
  add_filter 'lib/clients_cli/app.rb'
  add_filter 'lib/clients_cli/interactive_shell.rb'

  add_group 'Models', 'lib/clients/models'
  add_group 'Services', 'lib/clients/services'
  add_group 'CLI', 'lib/clients_cli'
  add_group 'Views', 'lib/clients_cli/views'

  minimum_coverage 90
  minimum_coverage_by_file 80
end

require 'bundler/setup'
require 'rspec'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:each) do
    allow($stdout).to receive(:puts)
    allow($stdout).to receive(:write)
  end
end
