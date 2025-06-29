class SearchResultsView
  def self.show_search_results(matching_clients, query)
    result = "🔍 Searching for: '#{query}'\n"
    
    if matching_clients.empty?
      result += "❌ No clients found matching '#{query}'\n"
    else
      result += "✅ Found #{matching_clients.length} client(s) matching '#{query}':\n\n"
      matching_clients.each_with_index do |client, index|
        result += <<~SCREEN
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
    
    result
  end
end 
