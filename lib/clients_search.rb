require 'thor'
require 'json'

class ClientsSearch < Thor
  desc "search QUERY", "Search through all clients in clients.json and return those with names partially matching a given search query"
  def search(query)
    clients_file = File.join(File.dirname(__FILE__), '..', 'data', 'clients.json')
    
    unless File.exist?(clients_file)
      puts "Error: clients.json file not found at #{clients_file}"
      exit 1
    end

    begin
      clients_data = JSON.parse(File.read(clients_file))
    rescue JSON::ParserError => e
      puts "Error: Invalid JSON in clients.json file: #{e.message}"
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
