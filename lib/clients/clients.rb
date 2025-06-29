require_relative 'services/load_data'
require_relative 'services/find_clients'
require_relative 'services/find_duplicate_clients'

class Clients
  def self.search(file_path, query)
    clients = all(file_path)
    FindClients.call(clients, query)
  end

  def self.find_duplicates(file_path)
    clients = all(file_path)
    FindDuplicateClients.call(clients)
  end

  def self.all(file_path)
    @clients ||= LoadData.call(file_path)
  end
end
