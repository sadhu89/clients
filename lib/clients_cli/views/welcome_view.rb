class WelcomeView
  def self.show_welcome(file_path, client_count)
    puts <<~SCREEN
      🔍 Clients Search REPL
      📁 Data file: #{file_path}
      👥 Total clients: #{client_count}

    SCREEN
    show_commands_help
    puts
  end

  def self.show_help(file_path, client_count)
    puts <<~SCREEN
      🔍 Clients Search REPL
      📁 Data file: #{file_path}
      👥 Total clients: #{client_count}

    SCREEN
    show_commands_help
  end

  private

  def self.show_commands_help
    puts <<~SCREEN
      Commands:
        • 's' or 'search' - Start a search
        • 'd' or 'duplicates' - Find duplicate emails
        • 'c' or 'clear' - Clear screen
        • 'h' or 'help' - Show this help
        • 'q' or 'quit' - Exit
    SCREEN
  end
end 
