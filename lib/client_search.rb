class FindClients
  def self.call(clients, query)
    return clients if query.nil? || query.empty?

    clients.select do |client|
      client['full_name']&.downcase&.include?(query.downcase)
    end
  end
end 
