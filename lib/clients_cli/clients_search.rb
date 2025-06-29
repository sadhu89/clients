require 'thor'
require 'json'
require_relative '../clients/models/client'
require_relative '../clients/services/find_clients'
require_relative '../clients/services/find_duplicate_clients'

class ClientsSearchError < StandardError; end

class ClientsSearch < Thor
  DEFAULT_FILE_PATH = File.join(File.dirname(__FILE__), '..', '..', 'data', 'clients.json')
  
  default_task :repl

  desc "repl", "Start an interactive REPL for searching clients"
  option :file, type: :string, aliases: '-f', desc: "Path to the clients JSON file"
  
  def repl
    file_path = options[:file] || DEFAULT_FILE_PATH
    unless File.exist?(file_path)
      puts "Error: File not found at #{file_path}"
      raise ClientsSearchError, "File not found at #{file_path}"
    end
    
    begin
      raw_clients = JSON.parse(File.read(file_path))
      clients = Client.from_json_array(raw_clients)
    rescue JSON::ParserError => e
      puts "Error: Invalid JSON in file #{file_path}: #{e.message}"
      raise ClientsSearchError, "Invalid JSON in file #{file_path}: #{e.message}"
    rescue Dry::Struct::Error => e
      puts "Error: Invalid client data in file #{file_path}: #{e.message}"
      raise ClientsSearchError, "Invalid client data in file #{file_path}: #{e.message}"
    end

    current_file_path = file_path
    current_clients = clients
    last_query = nil
    last_results = []

    puts "🔍 Clients Search REPL"
    puts "📁 Data file: #{current_file_path}"
    puts "👥 Total clients: #{current_clients.length}"
    puts
    puts "Commands:"
    puts "  • 's' or 'search' - Start a search"
    puts "  • 'd' or 'duplicates' - Find duplicate emails"
    puts "  • 'c' or 'clear' - Clear screen"
    puts "  • 'h' or 'help' - Show this help"
    puts "  • 'q' or 'quit' - Exit"
    puts

    loop do
      print "clients> "
      input = STDIN.gets&.chomp&.strip
      break if input.nil?
      
      case input.downcase
      when 'q', 'quit', 'exit'
        puts "👋 Goodbye!"
        break
      when 'h', 'help'
        puts "🔍 Clients Search REPL"
        puts "📁 Data file: #{current_file_path}"
        puts "👥 Total clients: #{current_clients.length}"
        puts
        puts "Commands:"
        puts "  • 's' or 'search' - Start a search"
        puts "  • 'd' or 'duplicates' - Find duplicate emails"
        puts "  • 'c' or 'clear' - Clear screen"
        puts "  • 'h' or 'help' - Show this help"
        puts "  • 'q' or 'quit' - Exit"
      when 'c', 'clear'
        system('clear') || system('cls')
        puts "🔍 Clients Search REPL"
        puts "📁 Data file: #{current_file_path}"
        puts "👥 Total clients: #{current_clients.length}"
        puts
      when 'd', 'duplicates'
        puts "🔍 Searching for duplicate emails..."
        duplicate_groups = FindDuplicateClients.call(current_clients)
        if duplicate_groups.empty?
          puts "✅ No duplicate email addresses found"
        else
          puts "⚠️  Found #{duplicate_groups.length} email address(es) with duplicates:"
          puts
          duplicate_groups.each do |email, clients|
            puts "📧 #{email} (#{clients.length} duplicates)"
            clients.each do |client|
              puts "   • #{client['full_name']} (ID: #{client['id']})"
            end
            puts
          end
        end
      when 's', 'search'
        search_mode(current_clients)
      when ''
        # Do nothing for empty input
      else
        puts "❌ Unknown command: '#{input}'"
        puts "💡 Type 'h' or 'help' for available commands"
      end
      puts
    end
  end

  desc "search", "Search for clients by name"
  option :file, type: :string, aliases: '-f', desc: "Path to the clients JSON file"
  
  def search(query)
    file_path = options[:file] || DEFAULT_FILE_PATH
    unless File.exist?(file_path)
      puts "Error: File not found at #{file_path}"
      raise ClientsSearchError, "File not found at #{file_path}"
    end
    
    begin
      raw_clients = JSON.parse(File.read(file_path))
      clients = Client.from_json_array(raw_clients)
    rescue JSON::ParserError => e
      puts "Error: Invalid JSON in file #{file_path}: #{e.message}"
      raise ClientsSearchError, "Invalid JSON in file #{file_path}: #{e.message}"
    rescue Dry::Struct::Error => e
      puts "Error: Invalid client data in file #{file_path}: #{e.message}"
      raise ClientsSearchError, "Invalid client data in file #{file_path}: #{e.message}"
    end

    matching_clients = FindClients.call(clients, query)
    display_search_results(matching_clients, query)
  end

  private

  def search_mode(clients)
    puts "🔍 Search mode"
    puts "💡 Type your search query or '/q' to return to main menu"
    puts

    loop do
      print "search> "
      query = STDIN.gets&.chomp&.strip
      break if query.nil?
      
      case query.downcase
      when '/q', '/quit'
        puts "👋 Returning to main menu"
        break
      when ''
        # Do nothing for empty input
      else
        puts "🔍 Searching for: '#{query}'"
        matching_clients = FindClients.call(clients, query)
        display_search_results(matching_clients, query)
      end
      puts
    end
  end

  def display_search_results(matching_clients, query)
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
end

