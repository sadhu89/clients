require_relative 'clients'
require_relative 'views/welcome_view'
require_relative 'views/search_results_view'
require_relative 'views/duplicate_results_view'
require_relative 'views/search_mode_view'
require_relative 'views/common_messages_view'
require_relative 'search_mode_shell'

class ReplShell
  def self.start(file_path)
    clients = Clients.load_clients(file_path)
    WelcomeView.show_welcome(file_path, Clients.count(clients))

    loop do
      print "clients> "
      input = STDIN.gets&.chomp&.strip
      break if input.nil?
      
      case input.downcase
      when 'q', 'quit', 'exit'
        CommonMessagesView.show_goodbye
        break
      when 'h', 'help'
        WelcomeView.show_help(file_path, Clients.count(clients))
      when 'c', 'clear'
        CommonMessagesView.clear_screen
        WelcomeView.show_welcome(file_path, Clients.count(clients))
      when 'd', 'duplicates'
        puts "🔍 Searching for duplicate emails..."
        DuplicateResultsView.show_duplicate_results(file_path)
      when 's', 'search'
        SearchModeShell.start(file_path)
      when ''
        # Do nothing for empty input
      else
        CommonMessagesView.show_unknown_command(input)
      end
      puts
    end
  end
end 
