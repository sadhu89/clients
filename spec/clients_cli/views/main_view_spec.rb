# frozen_string_literal: true

require_relative '../../../lib/clients_cli/views/main_view'

RSpec.describe MainView do
  let(:file_path) { '/path/to/clients.json' }
  let(:client_count) { 150 }

  describe '.show_welcome' do
    it 'displays welcome title' do
      result = described_class.show_welcome(file_path, client_count)
      expect(result).to include('Clients Search REPL')
    end

    it 'displays file path in welcome' do
      result = described_class.show_welcome(file_path, client_count)
      expect(result).to include(file_path)
    end

    it 'displays client count in welcome' do
      result = described_class.show_welcome(file_path, client_count)
      expect(result).to include(client_count.to_s)
    end
  end

  describe '.show_help' do
    it 'displays help title' do
      result = described_class.show_help(file_path, client_count)
      expect(result).to include('Clients Search REPL')
    end

    it 'displays file path in help' do
      result = described_class.show_help(file_path, client_count)
      expect(result).to include(file_path)
    end

    it 'displays client count in help' do
      result = described_class.show_help(file_path, client_count)
      expect(result).to include(client_count.to_s)
    end
  end

  describe '.show_unknown_command' do
    it 'displays unknown command message' do
      unknown_command = 'xyz'
      result = described_class.show_unknown_command(unknown_command)
      expect(result).to include('Unknown command')
    end

    it 'displays the command in unknown command message' do
      unknown_command = 'xyz'
      result = described_class.show_unknown_command(unknown_command)
      expect(result).to include(unknown_command)
    end
  end

  describe '.show_goodbye' do
    it 'displays goodbye message' do
      result = described_class.show_goodbye
      expect(result).to include('Goodbye')
    end
  end

  describe '.show_returning_to_menu' do
    it 'displays returning to menu message' do
      result = described_class.show_returning_to_menu
      expect(result).to include('Returning to main menu')
    end
  end

  describe 'private methods' do
    it 'includes search command help' do
      welcome_output = described_class.show_welcome(file_path, client_count)
      expect(welcome_output).to include("• 's' or 'search' - Start a search")
    end

    it 'includes duplicates command help' do
      welcome_output = described_class.show_welcome(file_path, client_count)
      expect(welcome_output).to include("• 'd' or 'duplicates' - Find duplicate emails")
    end

    it 'includes clear command help' do
      welcome_output = described_class.show_welcome(file_path, client_count)
      expect(welcome_output).to include("• 'c' or 'clear' - Clear screen")
    end

    it 'includes help command help' do
      welcome_output = described_class.show_welcome(file_path, client_count)
      expect(welcome_output).to include("• 'h' or 'help' - Show this help")
    end

    it 'includes quit command help' do
      welcome_output = described_class.show_welcome(file_path, client_count)
      expect(welcome_output).to include("• 'q' or 'quit' - Exit")
    end
  end
end
