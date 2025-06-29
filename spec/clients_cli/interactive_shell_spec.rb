# frozen_string_literal: true

require_relative '../../lib/clients_cli/interactive_shell'
require_relative '../../lib/clients_cli/views/main_view'
require_relative '../../lib/clients_cli/views/search_mode_view'
require_relative '../../lib/clients_cli/views/duplicate_results_view'
require_relative '../../lib/clients_cli/views/search_results_view'
require_relative '../../lib/clients_cli/router'
require_relative '../../lib/clients/models/client'

RSpec.describe InteractiveShell do
  let(:test_file_path) { 'spec/fixtures/test_clients.json' }
  let(:sample_clients) do
    [
      Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com'),
      Client.new(id: 2, full_name: 'Jane Smith', email: 'jane@example.com')
    ]
  end

  before do
    allow(Clients).to receive(:all).with(test_file_path).and_return(Dry::Monads::Success(sample_clients))
    allow(Clients).to receive(:find_duplicates).and_return(Dry::Monads::Success({}))
  end

  describe '.run' do
    it 'starts the interactive shell successfully' do
      expect(InteractiveShell).to receive(:run_main_loop).with(test_file_path, sample_clients)
      expect(MainView).to receive(:show_welcome).with(test_file_path, 2)

      InteractiveShell.run(test_file_path)
    end

    it 'returns Failure when Clients.all fails' do
      error = StandardError.new('File not found')
      allow(Clients).to receive(:all).with(test_file_path).and_return(Dry::Monads::Failure(error))

      result = InteractiveShell.run(test_file_path)
      expect(result).to be_failure
      expect(result.failure).to eq(error)
    end
  end
end
