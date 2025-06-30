# frozen_string_literal: true

# View class for displaying duplicate client results
class DuplicateResultsView
  def self.show_duplicate_results(duplicate_groups)
    result = "🔍 Searching for duplicate emails...\n"

    if duplicate_groups.empty?
      result += "✅ No duplicate email addresses found\n"
    else
      result += "⚠️  Found #{duplicate_groups.length} email address(es) with duplicates:\n\n"
      duplicate_groups.each do |email, clients|
        client_list = clients.map { |client| "   • #{client.full_name} (ID: #{client.id})" }.join("\n")
        result += <<~SCREEN
          📧 #{email} (#{clients.length} duplicates)
          #{client_list}

        SCREEN
      end
    end

    result
  end
end
