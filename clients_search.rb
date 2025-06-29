require 'thor'
require 'json'
require_relative 'lib/client_search'
require_relative 'lib/client_duplicates'

class ClientsSearch < Thor
  DEFAULT_FILE_PATH = File.join(File.dirname(__FILE__), 'data', 'clients.json')
  
  desc "search QUERY", "Search through all clients dataset and return those with names partially matching a given search query"
  option :file, type: :string, aliases: '-f', desc: "Path to the clients JSON file"
  
  def search(query)
    file_path = options[:file] || DEFAULT_FILE_PATH
    unless File.exist?(file_path)
      puts "Error: File not found at #{file_path}"
      exit 1
    end
    begin
      clients = JSON.parse(File.read(file_path))
    rescue JSON::ParserError => e
      puts "Error: Invalid JSON in file #{file_path}: #{e.message}"
      exit 1
    end

    matching_clients = FindClients.call(clients, query)

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

  desc "duplicates", "Find clients with duplicate email addresses in the dataset"
  option :file, type: :string, aliases: '-f', desc: "Path to the clients JSON file"
  
  def duplicates
    file_path = options[:file] || DEFAULT_FILE_PATH
    unless File.exist?(file_path)
      puts "Error: File not found at #{file_path}"
      exit 1
    end
    begin
      clients = JSON.parse(File.read(file_path))
    rescue JSON::ParserError => e
      puts "Error: Invalid JSON in file #{file_path}: #{e.message}"
      exit 1
    end

    duplicate_groups = FindDuplicateClients.call(clients)

    if duplicate_groups.empty?
      puts "No duplicate email addresses found in the dataset."
    else
      puts "Found #{duplicate_groups.length} email address(es) with duplicates:"
      puts
      duplicate_groups.each do |email, clients|
        puts "Email: #{email}"
        puts "Number of duplicates: #{clients.length}"
        puts "Clients with this email:"
        clients.each do |client|
          puts "  - ID: #{client['id']}, Name: #{client['full_name']}"
        end
        puts "-" * 40
      end
    end
  end
end
