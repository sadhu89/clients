class ClientSearcher
  def initialize(clients_data)
    @clients_data = clients_data
  end

  def search(query)
    return @clients_data if query.nil? || query.empty?
    
    matching_clients = @clients_data.select do |client|
      client['full_name']&.downcase&.include?(query.downcase)
    end
    
    matching_clients
  end

  def search_with_details(query)
    matching_clients = search(query)
    
    {
      query: query,
      count: matching_clients.length,
      clients: matching_clients
    }
  end
end 
