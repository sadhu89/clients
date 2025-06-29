# frozen_string_literal: true

require_relative '../models/client'

# Service class for finding duplicate clients based on email addresses
class FindDuplicateClients
  def self.call(clients)
    email_groups = clients.group_by { |client| client.email&.downcase }
    email_groups.select { |_email, clients| clients.length > 1 }
  end
end
