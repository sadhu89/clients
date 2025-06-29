require_relative '../clients/services/find_clients'
require_relative 'views/welcome_view'
require_relative 'views/search_results_view'
require_relative 'views/duplicate_results_view'
require_relative 'views/search_mode_view'
require_relative 'views/common_messages_view'
require_relative 'search_mode_shell'

class Shell
  def self.start(clients, file_path)
    WelcomeView.show_welcome(file_path, clients.length)

    loop do
      print "clients> "
      input = STDIN.gets&.chomp&.strip
      break if input.nil?
      
      case input.downcase
      when 'q', 'quit', 'exit'
        CommonMessagesView.show_goodbye
        break
      when 'h', 'help'
        WelcomeView.show_help(file_path, clients.length)
      when 'c', 'clear'
        CommonMessagesView.clear_screen
        WelcomeView.show_welcome(file_path, clients.length)
      when 'd', 'duplicates'
        puts "🔍 Searching for duplicate emails..."
        DuplicateResultsView.show_duplicate_results(clients)
      when 's', 'search'
        SearchModeShell.start(clients)
      when ''
        # Do nothing for empty input
      else
        CommonMessagesView.show_unknown_command(input)
      end
      puts
    end
  end
end 
