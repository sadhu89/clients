class SearchResultsView
  def self.show_search_results(matching_clients, query)
    if matching_clients.empty?
      puts "❌ No clients found matching '#{query}'"
    else
      puts "✅ Found #{matching_clients.length} client(s) matching '#{query}':"
      puts
      matching_clients.each_with_index do |client, index|
        puts <<~SCREEN
          #{index + 1}. #{client.full_name}
             📧 #{client.email}
             🆔 ID: #{client.id}
             Name: #{client.full_name}
             Email: #{client.email}
             ID: #{client.id}
          #{'-' * 40}

        SCREEN
      end
    end
  end
end 
