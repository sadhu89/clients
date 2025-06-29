require 'json'
require_relative '../clients/models/client'

class ClientsSearchError < StandardError; end

class DataLoader
  def self.load_clients(file_path)
    
    unless File.exist?(file_path)
      puts "Error: File not found at #{file_path}"
      raise ClientsSearchError, "File not found at #{file_path}"
    end
    
    begin
      raw_clients = JSON.parse(File.read(file_path))
      Client.from_json_array(raw_clients)
    rescue JSON::ParserError => e
      puts "Error: Invalid JSON in file #{file_path}: #{e.message}"
      raise ClientsSearchError, "Invalid JSON in file #{file_path}: #{e.message}"
    rescue Dry::Struct::Error => e
      puts "Error: Invalid client data in file #{file_path}: #{e.message}"
      raise ClientsSearchError, "Invalid client data in file #{file_path}: #{e.message}"
    end
  end
end 
