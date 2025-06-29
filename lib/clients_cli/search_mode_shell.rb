require_relative '../clients/services/find_clients'
require_relative 'views/search_mode_view'
require_relative 'views/common_messages_view'
require_relative 'views/search_results_view'

class SearchModeShell
  def self.start(clients)
    SearchModeView.show_search_mode_help

    loop do
      print "search> "
      query = STDIN.gets&.chomp&.strip
      break if query.nil?
      
      case query.downcase
      when '/q', '/quit'
        CommonMessagesView.show_returning_to_menu
        break
      when ''
        # Do nothing for empty input
      else
        puts "🔍 Searching for: '#{query}'"
        matching_clients = FindClients.call(clients, query)
        SearchResultsView.show_search_results(matching_clients, query)
      end
      puts
    end
  end
end 
