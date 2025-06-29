# frozen_string_literal: true

require 'dry/monads'
require_relative 'services/load_data'
require_relative 'services/find_clients'
require_relative 'services/find_duplicate_clients'

# Main class for managing client data and operations
class Clients
  extend Dry::Monads[:result, :do]

  def self.search(file_path, query)
    clients = yield all(file_path)
    Success(FindClients.call(clients, query))
  end

  def self.find_duplicates(file_path)
    clients = yield all(file_path)
    Success(FindDuplicateClients.call(clients))
  end

  def self.all(file_path)
    @all ||= LoadData.call(file_path)
  end
end
