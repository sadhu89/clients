require_relative '../clients'

class DuplicateResultsView
  def self.show_duplicate_results(file_path)
    duplicate_groups = Clients.find_duplicates(file_path)
    
    if duplicate_groups.empty?
      puts "✅ No duplicate email addresses found"
    else
      puts "⚠️  Found #{duplicate_groups.length} email address(es) with duplicates:"
      puts
      duplicate_groups.each do |email, clients|
        client_list = clients.map { |client| "   • #{client.full_name} (ID: #{client.id})" }.join("\n")
        puts <<~SCREEN
          📧 #{email} (#{clients.length} duplicates)
          #{client_list}

        SCREEN
      end
    end
  end
end 
