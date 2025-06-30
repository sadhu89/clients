# frozen_string_literal: true

# View class for displaying main menu and help information
class MainView
  def self.show_welcome(file_path, client_count)
    <<~SCREEN
      🔍 Clients Search REPL
      📁 Data file: #{file_path}
      👥 Total clients: #{client_count}

      #{show_commands_help}

    SCREEN
  end

  def self.show_help(file_path, client_count)
    <<~SCREEN
      🔍 Clients Search REPL
      📁 Data file: #{file_path}
      👥 Total clients: #{client_count}

      #{show_commands_help}
    SCREEN
  end

  def self.show_unknown_command(input)
    <<~SCREEN
      ❌ Unknown command: '#{input}'
      💡 Type 'h' or 'help' for available commands
    SCREEN
  end

  def self.show_goodbye
    "👋 Goodbye!\n"
  end

  def self.show_returning_to_menu
    "👋 Returning to main menu\n"
  end

  def self.show_commands_help
    <<~SCREEN
      Commands:
        • 's' or 'search' - Start a search
        • 'd' or 'duplicates' - Find duplicate emails
        • 'c' or 'clear' - Clear screen
        • 'h' or 'help' - Show this help
        • 'q' or 'quit' - Exit
    SCREEN
  end
end
