# frozen_string_literal: true

require_relative '../../lib/clients_cli/interactive_shell'
require_relative '../../lib/clients_cli/views/main_view'
require_relative '../../lib/clients_cli/views/search_mode_view'
require_relative '../../lib/clients_cli/views/duplicate_results_view'
require_relative '../../lib/clients_cli/views/search_results_view'
require_relative '../../lib/clients_cli/router'

RSpec.describe InteractiveShell do
  let(:test_file_path) { 'spec/fixtures/test_clients.json' }
  let(:sample_clients) do
    [
      double('Client', id: 1, full_name: 'John Doe', email: 'john@example.com'),
      double('Client', id: 2, full_name: 'Jane Smith', email: 'jane@example.com')
    ]
  end

  before do
    allow(Clients).to receive(:all).with(test_file_path).and_return(Dry::Monads::Success(sample_clients))
    allow(MainView).to receive(:show_welcome).and_return('Welcome message')
    allow(MainView).to receive(:show_goodbye).and_return('Goodbye message')
    allow(MainView).to receive(:show_returning_to_menu).and_return('Returning message')
    allow(MainView).to receive(:show_help).and_return('Help message')
    allow(MainView).to receive(:show_unknown_command).and_return('Unknown command message')
    allow(SearchModeView).to receive(:show_search_mode_help).and_return('Search help message')
    allow(DuplicateResultsView).to receive(:show_duplicate_results).and_return('Duplicate results')
    allow(SearchResultsView).to receive(:show_search_results).and_return('Search results')
    allow(Router).to receive(:handle_main_shell).and_return(:continue)
    allow(Router).to receive(:handle_search_mode).and_return(:continue)
    allow(Clients).to receive(:find_duplicates).and_return(Dry::Monads::Success({}))
  end

  describe '.start' do
    it 'starts the interactive shell successfully' do
      expect(InteractiveShell).to receive(:run_main_loop).with(test_file_path, sample_clients)
      expect(MainView).to receive(:show_welcome).with(test_file_path, 2)

      InteractiveShell.start(test_file_path)
    end

    it 'returns Failure when Clients.all fails' do
      error = ClientsSearchError.new('File not found')
      allow(Clients).to receive(:all).with(test_file_path).and_return(Dry::Monads::Failure(error))
      
      result = InteractiveShell.start(test_file_path)
      expect(result).to be_failure
      expect(result.failure).to eq(error)
    end
  end

  describe '.run_main_loop' do
    it 'runs the main loop until quit' do
      allow($stdin).to receive(:gets).and_return('quit', nil)
      allow(Router).to receive(:handle_main_shell).with('quit').and_return(:quit)
      expect(MainView).to receive(:show_goodbye)
      expect { InteractiveShell.run_main_loop(test_file_path, sample_clients) }.not_to raise_error
    end

    it 'handles nil input gracefully' do
      allow($stdin).to receive(:gets).and_return(nil)
      expect { InteractiveShell.run_main_loop(test_file_path, sample_clients) }.not_to raise_error
    end

    it 'executes puts in run_main_loop when not breaking immediately' do
      # Simulate two commands: first continues, second triggers break
      allow($stdin).to receive(:gets).and_return('help', 'quit', nil)
      allow(Router).to receive(:handle_main_shell).with('help').and_return(:show_help)
      allow(Router).to receive(:handle_main_shell).with('quit').and_return(:quit)
      expect(InteractiveShell).to receive(:handle_main_action).with(:show_help, test_file_path, sample_clients, 'help')
      expect(MainView).to receive(:show_goodbye)
      expect { InteractiveShell.run_main_loop(test_file_path, sample_clients) }.not_to raise_error
    end
  end

  describe '.handle_main_action' do
    it 'handles show_help action' do
      expect(InteractiveShell).to receive(:handle_show_help).with(test_file_path, sample_clients)
      InteractiveShell.handle_main_action(:show_help, test_file_path, sample_clients, 'help')
    end

    it 'handles clear_screen action' do
      expect(InteractiveShell).to receive(:handle_clear_screen).with(test_file_path, sample_clients)
      InteractiveShell.handle_main_action(:clear_screen, test_file_path, sample_clients, 'clear')
    end

    it 'handles enter_search_mode action' do
      expect(InteractiveShell).to receive(:start_search_mode).with(test_file_path)
      InteractiveShell.handle_main_action(:enter_search_mode, test_file_path, sample_clients, 'search')
    end

    it 'handles show_duplicates action' do
      expect(InteractiveShell).to receive(:handle_show_duplicates).with(test_file_path)
      InteractiveShell.handle_main_action(:show_duplicates, test_file_path, sample_clients, 'duplicates')
    end

    it 'handles unknown_command action' do
      expect(MainView).to receive(:show_unknown_command).with('invalid')
      InteractiveShell.handle_main_action(:unknown_command, test_file_path, sample_clients, 'invalid')
    end

    it 'handles continue action (does nothing)' do
      expect { InteractiveShell.handle_main_action(:continue, test_file_path, sample_clients, '') }.not_to raise_error
    end

    it 'does nothing for unknown action' do
      expect { InteractiveShell.handle_main_action(:not_a_real_command, test_file_path, sample_clients, 'foo') }.not_to raise_error
    end
  end

  describe '.handle_show_help' do
    it 'shows help message' do
      expect(MainView).to receive(:show_help).with(test_file_path, 2)
      InteractiveShell.handle_show_help(test_file_path, sample_clients)
    end
  end

  describe '.handle_clear_screen' do
    it 'clears screen and shows welcome message' do
      expect(InteractiveShell).to receive(:clear_screen)
      expect(MainView).to receive(:show_welcome).with(test_file_path, 2)
      InteractiveShell.handle_clear_screen(test_file_path, sample_clients)
    end
  end

  describe '.handle_show_duplicates' do
    it 'finds and displays duplicate results successfully' do
      duplicate_groups = { 'test@example.com' => sample_clients }
      allow(Clients).to receive(:find_duplicates).with(test_file_path).and_return(Dry::Monads::Success(duplicate_groups))
      expect(DuplicateResultsView).to receive(:show_duplicate_results).with(duplicate_groups)
      InteractiveShell.handle_show_duplicates(test_file_path)
    end

    it 'returns Failure when find_duplicates fails' do
      error = ClientsSearchError.new('File not found')
      allow(Clients).to receive(:find_duplicates).with(test_file_path).and_return(Dry::Monads::Failure(error))
      
      result = InteractiveShell.handle_show_duplicates(test_file_path)
      expect(result).to be_failure
      expect(result.failure).to eq(error)
    end
  end

  describe '.clear_screen' do
    it 'calls system clear command' do
      expect(InteractiveShell).to receive(:system).with('clear').and_return(true)
      InteractiveShell.clear_screen
    end

    it 'falls back to cls if clear fails' do
      expect(InteractiveShell).to receive(:system).with('clear').and_return(false)
      expect(InteractiveShell).to receive(:system).with('cls').and_return(true)
      InteractiveShell.clear_screen
    end
  end

  describe '.start_search_mode' do
    it 'shows search mode help and starts search loop' do
      expect(SearchModeView).to receive(:show_search_mode_help)
      expect(InteractiveShell).to receive(:run_search_loop).with(test_file_path)
      InteractiveShell.start_search_mode(test_file_path)
    end
  end

  describe '.run_search_loop' do
    it 'runs the search loop until quit' do
      allow($stdin).to receive(:gets).and_return('/q', nil)
      allow(Router).to receive(:handle_search_mode).with('/q').and_return(:quit_search_mode)
      expect(MainView).to receive(:show_returning_to_menu)
      expect { InteractiveShell.run_search_loop(test_file_path) }.not_to raise_error
    end

    it 'handles nil input gracefully' do
      allow($stdin).to receive(:gets).and_return(nil)
      expect { InteractiveShell.run_search_loop(test_file_path) }.not_to raise_error
    end

    it 'executes puts in run_search_loop when not breaking immediately' do
      allow($stdin).to receive(:gets).and_return('search', '/q', nil)
      allow(Router).to receive(:handle_search_mode).with('search').and_return(:continue)
      allow(Router).to receive(:handle_search_mode).with('/q').and_return(:quit_search_mode)
      expect(MainView).to receive(:show_returning_to_menu)
      expect { InteractiveShell.run_search_loop(test_file_path) }.not_to raise_error
    end

    it 'handles search command successfully' do
      allow($stdin).to receive(:gets).and_return('john', '/q', nil)
      allow(Router).to receive(:handle_search_mode).with('john').and_return(:search)
      allow(Router).to receive(:handle_search_mode).with('/q').and_return(:quit_search_mode)
      matching_clients = [sample_clients.first]
      allow(Clients).to receive(:search).with(test_file_path, 'john').and_return(Dry::Monads::Success(matching_clients))
      expect(SearchResultsView).to receive(:show_search_results).with(matching_clients, 'john')
      expect(MainView).to receive(:show_returning_to_menu)
      expect { InteractiveShell.run_search_loop(test_file_path) }.not_to raise_error
    end

    it 'handles search command failure' do
      allow($stdin).to receive(:gets).and_return('john', '/q', nil)
      allow(Router).to receive(:handle_search_mode).with('john').and_return(:search)
      allow(Router).to receive(:handle_search_mode).with('/q').and_return(:quit_search_mode)
      error = ClientsSearchError.new('File not found')
      allow(Clients).to receive(:search).with(test_file_path, 'john').and_return(Dry::Monads::Failure(error))
      expect { InteractiveShell.run_search_loop(test_file_path) }.not_to raise_error
    end
  end
end
