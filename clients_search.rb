require 'thor'
require 'json'
require_relative 'lib/client_searcher'

class ClientsSearch < Thor
  DEFAULT_FILE_PATH = File.join(File.dirname(__FILE__), 'data', 'clients.json')
  
  desc "search QUERY", "Search through all clients in the JSON file (via --file or default) and return those with names partially matching a given search query"
  option :file, type: :string, aliases: '-f', desc: "Path to the clients JSON file"
  
  def search(query)
    file_path = options[:file] || DEFAULT_FILE_PATH
    unless File.exist?(file_path)
      puts "Error: File not found at #{file_path}"
      exit 1
    end
    begin
      clients_data = JSON.parse(File.read(file_path))
    rescue JSON::ParserError => e
      puts "Error: Invalid JSON in file #{file_path}: #{e.message}"
      exit 1
    end

    searcher = ClientSearcher.new(clients_data)
    result = searcher.search_with_details(query)

    if result[:count] == 0
      puts "No clients found matching '#{query}'"
    else
      puts "Found #{result[:count]} client(s) matching '#{query}':"
      puts
      result[:clients].each do |client|
        puts "ID: #{client['id']}"
        puts "Name: #{client['full_name']}"
        puts "Email: #{client['email']}"
        puts "-" * 40
      end
    end
  end
end
