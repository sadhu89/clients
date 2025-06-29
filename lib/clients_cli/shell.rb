require_relative '../clients/services/find_clients'
require_relative 'formatter'

class Shell
  def self.start(clients, file_path)
    Formatter.show_welcome(file_path, clients.length)

    loop do
      print "clients> "
      input = STDIN.gets&.chomp&.strip
      break if input.nil?
      
      case input.downcase
      when 'q', 'quit', 'exit'
        Formatter.show_goodbye
        break
      when 'h', 'help'
        Formatter.show_help(file_path, clients.length)
      when 'c', 'clear'
        Formatter.clear_screen
        Formatter.show_welcome(file_path, clients.length)
      when 'd', 'duplicates'
        puts "🔍 Searching for duplicate emails..."
        Formatter.show_duplicate_results(clients)
      when 's', 'search'
        search_mode(clients)
      when ''
        # Do nothing for empty input
      else
        Formatter.show_unknown_command(input)
      end
      puts
    end
  end

  private

  def self.search_mode(clients)
    Formatter.show_search_mode_help

    loop do
      print "search> "
      query = STDIN.gets&.chomp&.strip
      break if query.nil?
      
      case query.downcase
      when '/q', '/quit'
        Formatter.show_returning_to_menu
        break
      when ''
        # Do nothing for empty input
      else
        puts "🔍 Searching for: '#{query}'"
        matching_clients = FindClients.call(clients, query)
        Formatter.show_search_results(matching_clients, query)
      end
      puts
    end
  end
end 
