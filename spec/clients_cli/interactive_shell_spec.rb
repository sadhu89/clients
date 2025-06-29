# frozen_string_literal: true

require_relative '../../lib/clients_cli/interactive_shell'
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
    allow(Clients).to receive(:all).with(test_file_path).and_return(sample_clients)
    allow(MainView).to receive(:show_welcome).and_return('Welcome message')
    allow(MainView).to receive(:show_help).and_return('Help message')
    allow(MainView).to receive(:show_goodbye).and_return('Goodbye message')
    allow(MainView).to receive(:show_unknown_command).and_return('Unknown command message')
    allow(MainView).to receive(:show_returning_to_menu).and_return('Returning message')
    allow(DuplicateResultsView).to receive(:show_duplicate_results).and_return('Duplicate results')
    allow(SearchModeView).to receive(:show_search_mode_help).and_return('Search mode help')
    allow(SearchResultsView).to receive(:show_search_results).and_return('Search results')
    allow($stdout).to receive(:puts).with('').at_least(:once)
    allow($stdout).to receive(:puts).with(no_args).at_least(:once)
  end

  describe '.start' do
    it 'loads clients and shows welcome message' do
      expect(Clients).to receive(:all).with(test_file_path)
      expect(MainView).to receive(:show_welcome).with(test_file_path, 2)
      expect($stdout).to receive(:puts).with('Welcome message')

      # Mock STDIN to return 'q' to quit immediately
      allow($stdin).to receive(:gets).and_return("q\n")
      allow($stdout).to receive(:print).with('clients> ')
      allow($stdout).to receive(:puts).with('Goodbye message')
      allow($stdout).to receive(:puts).with('')

      InteractiveShell.start(test_file_path)
    end

    it 'handles quit command' do
      allow($stdin).to receive(:gets).and_return("q\n")
      allow($stdout).to receive(:print).with('clients> ')
      allow($stdout).to receive(:puts).with('Welcome message')
      allow($stdout).to receive(:puts).with('Goodbye message')
      allow($stdout).to receive(:puts).with('')

      InteractiveShell.start(test_file_path)
    end

    it 'handles help command' do
      allow($stdin).to receive(:gets).and_return("h\n", "q\n")
      allow($stdout).to receive(:print).with('clients> ').twice
      allow($stdout).to receive(:puts).with('Welcome message')
      allow($stdout).to receive(:puts).with('Help message')
      allow($stdout).to receive(:puts).with('Goodbye message')
      allow($stdout).to receive(:puts).with('').twice

      InteractiveShell.start(test_file_path)
    end

    it 'handles clear command' do
      allow($stdin).to receive(:gets).and_return("c\n", "q\n")
      allow($stdout).to receive(:print).with('clients> ').twice
      allow($stdout).to receive(:puts).with('Welcome message').twice
      allow($stdout).to receive(:puts).with('Goodbye message')
      expect(InteractiveShell).to receive(:clear_screen)

      InteractiveShell.start(test_file_path)
    end

    it 'handles duplicates command' do
      allow($stdin).to receive(:gets).and_return("d\n", "q\n")
      allow($stdout).to receive(:print).with('clients> ').twice
      allow($stdout).to receive(:puts).with('Welcome message')
      allow($stdout).to receive(:puts).with('Duplicate results')
      allow($stdout).to receive(:puts).with('Goodbye message')
      allow($stdout).to receive(:puts).with('')
      expect(Clients).to receive(:find_duplicates).with(test_file_path)

      InteractiveShell.start(test_file_path)
    end

    it 'handles unknown command' do
      allow($stdin).to receive(:gets).and_return("unknown\n", "q\n")
      allow($stdout).to receive(:print).with('clients> ').twice
      allow($stdout).to receive(:puts).with('Welcome message')
      allow($stdout).to receive(:puts).with('Unknown command message')
      allow($stdout).to receive(:puts).with('Goodbye message')
      allow($stdout).to receive(:puts).with('')

      InteractiveShell.start(test_file_path)
    end

    it 'handles nil input (EOF)' do
      allow($stdin).to receive(:gets).and_return(nil)
      allow($stdout).to receive(:print).with('clients> ')
      allow($stdout).to receive(:puts).with('Welcome message')

      InteractiveShell.start(test_file_path)
    end
  end

  describe '.clear_screen' do
    it 'calls system clear command' do
      expect(InteractiveShell).to receive(:system).with('clear').and_return(true)
      InteractiveShell.clear_screen
    end

    it 'falls back to cls command on Windows' do
      expect(InteractiveShell).to receive(:system).with('clear').and_return(false)
      expect(InteractiveShell).to receive(:system).with('cls').and_return(true)
      InteractiveShell.clear_screen
    end
  end

  describe '.start_search_mode' do
    it 'shows search mode help and handles search' do
      allow($stdin).to receive(:gets).and_return("john\n", "/q\n")
      allow($stdout).to receive(:print).with('search> ').twice
      allow($stdout).to receive(:puts).with('Search mode help')
      allow($stdout).to receive(:puts).with('Search results')
      allow($stdout).to receive(:puts).with('Returning message')
      allow($stdout).to receive(:puts).with('')
      expect(Clients).to receive(:search).with(test_file_path, 'john')

      InteractiveShell.start_search_mode(test_file_path)
    end

    it 'handles quit search mode command' do
      allow($stdin).to receive(:gets).and_return("/q\n")
      allow($stdout).to receive(:print).with('search> ')
      allow($stdout).to receive(:puts).with('Search mode help')
      allow($stdout).to receive(:puts).with('Returning message')
      allow($stdout).to receive(:puts).with('')

      InteractiveShell.start_search_mode(test_file_path)
    end

    it 'handles nil input in search mode' do
      allow($stdin).to receive(:gets).and_return(nil)
      allow($stdout).to receive(:print).with('search> ')
      allow($stdout).to receive(:puts).with('Search mode help')

      InteractiveShell.start_search_mode(test_file_path)
    end
  end
end
