require_relative 'loader'
require_relative '../clients/services/find_clients'
require_relative '../clients/services/find_duplicate_clients'

class Clients
  def self.count(clients)
    clients.length
  end

  def self.search(file_path, query)
    clients = load_clients(file_path)
    FindClients.call(clients, query)
  end

  def self.find_duplicates(file_path)
    clients = load_clients(file_path)
    FindDuplicateClients.call(clients)
  end

  def self.default_file_path
    DataLoader::DEFAULT_FILE_PATH
  end

  def self.load_clients(file_path)
    @clients ||= DataLoader.load_clients(file_path)
  end
end 
