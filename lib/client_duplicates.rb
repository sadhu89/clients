class FindDuplicateClients
  def self.call(clients)
    email_groups = clients.group_by { |client| client['email']&.downcase }
    duplicates = email_groups.select { |email, clients| clients.length > 1 }
    
    duplicates.transform_values do |clients|
      clients.map do |client|
        {
          'id' => client['id'],
          'full_name' => client['full_name'],
          'email' => client['email']
        }
      end
    end
  end
end 
