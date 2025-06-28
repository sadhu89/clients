require 'thor'
require 'json'

class ClientsSearch < Thor
  DEFAULT_FILE_PATH = File.join(File.dirname(__FILE__), '..', 'data', 'clients.json')
  
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

    matching_clients = clients_data.select do |client|
      client['full_name']&.downcase&.include?(query.downcase)
    end

    if matching_clients.empty?
      puts "No clients found matching '#{query}'"
    else
      puts "Found #{matching_clients.length} client(s) matching '#{query}':"
      puts
      matching_clients.each do |client|
        puts "ID: #{client['id']}"
        puts "Name: #{client['full_name']}"
        puts "Email: #{client['email']}"
        puts "-" * 40
      end
    end
  end
end
