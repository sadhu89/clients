require_relative '../clients/services/find_duplicate_clients'

class Formatter
  def self.show_welcome(file_path, client_count)
    puts "🔍 Clients Search REPL"
    puts "📁 Data file: #{file_path}"
    puts "👥 Total clients: #{client_count}"
    puts
    show_commands_help
    puts
  end

  def self.show_help(file_path, client_count)
    puts "🔍 Clients Search REPL"
    puts "📁 Data file: #{file_path}"
    puts "👥 Total clients: #{client_count}"
    puts
    show_commands_help
  end

  def self.show_search_results(matching_clients, query)
    if matching_clients.empty?
      puts "❌ No clients found matching '#{query}'"
    else
      puts "✅ Found #{matching_clients.length} client(s) matching '#{query}':"
      puts
      matching_clients.each_with_index do |client, index|
        puts "#{index + 1}. #{client.full_name}"
        puts "   📧 #{client.email}"
        puts "   🆔 ID: #{client.id}"
        puts "   Name: #{client.full_name}"
        puts "   Email: #{client.email}"
        puts "   ID: #{client.id}"
        puts "-" * 40
        puts
      end
    end
  end

  def self.show_duplicate_results(clients)
    duplicate_groups = FindDuplicateClients.call(clients)
    
    if duplicate_groups.empty?
      puts "✅ No duplicate email addresses found"
    else
      puts "⚠️  Found #{duplicate_groups.length} email address(es) with duplicates:"
      puts
      duplicate_groups.each do |email, clients|
        puts "📧 #{email} (#{clients.length} duplicates)"
        clients.each do |client|
          puts "   • #{client.full_name} (ID: #{client.id})"
        end
        puts
      end
    end
  end

  def self.show_search_mode_help
    puts "🔍 Search mode"
    puts "💡 Type your search query or '/q' to return to main menu"
    puts
  end

  def self.show_unknown_command(input)
    puts "❌ Unknown command: '#{input}'"
    puts "💡 Type 'h' or 'help' for available commands"
  end

  def self.show_goodbye
    puts "👋 Goodbye!"
  end

  def self.show_returning_to_menu
    puts "👋 Returning to main menu"
  end

  def self.clear_screen
    system('clear') || system('cls')
  end

  private

  def self.show_commands_help
    puts "Commands:"
    puts "  • 's' or 'search' - Start a search"
    puts "  • 'd' or 'duplicates' - Find duplicate emails"
    puts "  • 'c' or 'clear' - Clear screen"
    puts "  • 'h' or 'help' - Show this help"
    puts "  • 'q' or 'quit' - Exit"
  end
end 
