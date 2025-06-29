require_relative '../models/client'

class FindDuplicateClients
  def self.call(clients)
    email_groups = clients.group_by { |client| client.email&.downcase }
    email_groups.select { |email, clients| clients.length > 1 }
  end
end 
