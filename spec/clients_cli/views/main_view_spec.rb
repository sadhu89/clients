# frozen_string_literal: true

require_relative '../../../lib/clients_cli/views/main_view'

RSpec.describe MainView do
  let(:file_path) { '/path/to/clients.json' }
  let(:client_count) { 150 }

  describe '.show_welcome' do
    it 'displays welcome message with file path and client count' do
      result = MainView.show_welcome(file_path, client_count)
      expect(result).to include('Clients Search REPL')
      expect(result).to include(file_path)
      expect(result).to include(client_count.to_s)
    end
  end

  describe '.show_help' do
    it 'displays help message with file path and client count' do
      result = MainView.show_help(file_path, client_count)
      expect(result).to include('Clients Search REPL')
      expect(result).to include(file_path)
      expect(result).to include(client_count.to_s)
    end
  end

  describe '.show_unknown_command' do
    it 'displays unknown command message with the command' do
      unknown_command = 'xyz'
      result = MainView.show_unknown_command(unknown_command)
      expect(result).to include('Unknown command')
      expect(result).to include(unknown_command)
    end
  end

  describe '.show_goodbye' do
    it 'displays goodbye message' do
      result = MainView.show_goodbye
      expect(result).to include('Goodbye')
    end
  end

  describe '.show_returning_to_menu' do
    it 'displays returning to menu message' do
      result = MainView.show_returning_to_menu
      expect(result).to include('Returning to main menu')
    end
  end

  describe 'private methods' do
    it 'includes all command help in output' do
      welcome_output = MainView.show_welcome(file_path, client_count)

      expect(welcome_output).to include("• 's' or 'search' - Start a search")
      expect(welcome_output).to include("• 'd' or 'duplicates' - Find duplicate emails")
      expect(welcome_output).to include("• 'c' or 'clear' - Clear screen")
      expect(welcome_output).to include("• 'h' or 'help' - Show this help")
      expect(welcome_output).to include("• 'q' or 'quit' - Exit")
    end
  end
end
