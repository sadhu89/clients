class FindClients
  def self.call(clients_data, query)
    return clients_data if query.nil? || query.empty?

    clients_data.select do |client|
      client['full_name']&.downcase&.include?(query.downcase)
    end
  end
end 
