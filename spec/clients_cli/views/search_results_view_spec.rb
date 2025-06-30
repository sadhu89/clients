# frozen_string_literal: true

require_relative '../../../lib/clients_cli/views/search_results_view'
require_relative '../../../lib/clients/models/client'

RSpec.describe SearchResultsView do
  let(:john_doe) { Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com') }
  let(:jane_smith) { Client.new(id: 2, full_name: 'Jane Smith', email: 'jane@example.com') }
  let(:bob_johnson) { Client.new(id: 3, full_name: 'Bob Johnson', email: 'bob@example.com') }

  describe '.show_search_results' do
    context 'when no results found' do
      it 'displays search message' do
        query = 'nonexistent'
        result = described_class.show_search_results([], query)
        expect(result).to include('Searching for:')
      end

      it 'displays no results message' do
        query = 'nonexistent'
        result = described_class.show_search_results([], query)
        expect(result).to include('No clients found')
      end
    end

    context 'when single result found' do
      it 'displays search message for single result' do
        query = 'john'
        matching_clients = [john_doe]
        result = described_class.show_search_results(matching_clients, query)
        expect(result).to include('Searching for:')
      end

      it 'displays found message for single result' do
        query = 'john'
        matching_clients = [john_doe]
        result = described_class.show_search_results(matching_clients, query)
        expect(result).to include('Found')
      end

      it 'displays client name for single result' do
        query = 'john'
        matching_clients = [john_doe]
        result = described_class.show_search_results(matching_clients, query)
        expect(result).to include('John Doe')
      end

      it 'displays search header for single result' do
        query = 'john'
        matching_clients = [john_doe]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include("🔍 Searching for: '#{query}'")
      end

      it 'displays found summary for single result' do
        query = 'john'
        matching_clients = [john_doe]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include("✅ Found 1 client(s) matching '#{query}':")
      end

      it 'displays client number for single result' do
        query = 'john'
        matching_clients = [john_doe]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('1. John Doe')
      end

      it 'displays client email for single result' do
        query = 'john'
        matching_clients = [john_doe]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   📧 john@example.com')
      end

      it 'displays client id for single result' do
        query = 'john'
        matching_clients = [john_doe]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   🆔 ID: 1')
      end

      it 'displays client name detail for single result' do
        query = 'john'
        matching_clients = [john_doe]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   Name: John Doe')
      end

      it 'displays client email detail for single result' do
        query = 'john'
        matching_clients = [john_doe]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   Email: john@example.com')
      end

      it 'displays client id detail for single result' do
        query = 'john'
        matching_clients = [john_doe]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   ID: 1')
      end

      it 'displays separator for single result' do
        query = 'john'
        matching_clients = [john_doe]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('-' * 40)
      end
    end

    context 'when multiple results found' do
      it 'displays search header for multiple results' do
        query = 'doe'
        matching_clients = [john_doe, jane_smith]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include("🔍 Searching for: '#{query}'")
      end

      it 'displays found summary for multiple results' do
        query = 'doe'
        matching_clients = [john_doe, jane_smith]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include("✅ Found 2 client(s) matching '#{query}':")
      end

      it 'displays first client number for multiple results' do
        query = 'doe'
        matching_clients = [john_doe, jane_smith]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('1. John Doe')
      end

      it 'displays second client number for multiple results' do
        query = 'doe'
        matching_clients = [john_doe, jane_smith]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('2. Jane Smith')
      end

      it 'displays first client email for multiple results' do
        query = 'doe'
        matching_clients = [john_doe, jane_smith]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   📧 john@example.com')
      end

      it 'displays second client email for multiple results' do
        query = 'doe'
        matching_clients = [john_doe, jane_smith]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   📧 jane@example.com')
      end

      it 'displays first client id for multiple results' do
        query = 'doe'
        matching_clients = [john_doe, jane_smith]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   🆔 ID: 1')
      end

      it 'displays second client id for multiple results' do
        query = 'doe'
        matching_clients = [john_doe, jane_smith]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   🆔 ID: 2')
      end
    end

    context 'when handling edge cases' do
      it 'displays client number for empty name client' do
        query = 'test'
        empty_name_client = Client.new(id: 4, full_name: '', email: 'test@example.com')
        matching_clients = [empty_name_client]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('1. ')
      end

      it 'displays client email for empty name client' do
        query = 'test'
        empty_name_client = Client.new(id: 4, full_name: '', email: 'test@example.com')
        matching_clients = [empty_name_client]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   📧 test@example.com')
      end

      it 'displays client id for empty name client' do
        query = 'test'
        empty_name_client = Client.new(id: 4, full_name: '', email: 'test@example.com')
        matching_clients = [empty_name_client]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   🆔 ID: 4')
      end

      it 'displays client name detail for empty name client' do
        query = 'test'
        empty_name_client = Client.new(id: 4, full_name: '', email: 'test@example.com')
        matching_clients = [empty_name_client]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   Name: ')
      end

      it 'displays client email detail for empty name client' do
        query = 'test'
        empty_name_client = Client.new(id: 4, full_name: '', email: 'test@example.com')
        matching_clients = [empty_name_client]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   Email: test@example.com')
      end

      it 'displays client id detail for empty name client' do
        query = 'test'
        empty_name_client = Client.new(id: 4, full_name: '', email: 'test@example.com')
        matching_clients = [empty_name_client]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   ID: 4')
      end

      it 'displays client name for special character client' do
        query = 'jose'
        special_client = Client.new(id: 5, full_name: 'José María', email: 'jose@example.com')
        matching_clients = [special_client]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('1. José María')
      end

      it 'displays client email for special character client' do
        query = 'jose'
        special_client = Client.new(id: 5, full_name: 'José María', email: 'jose@example.com')
        matching_clients = [special_client]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   📧 jose@example.com')
      end

      it 'displays client id for special character client' do
        query = 'jose'
        special_client = Client.new(id: 5, full_name: 'José María', email: 'jose@example.com')
        matching_clients = [special_client]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   🆔 ID: 5')
      end

      it 'displays client name detail for special character client' do
        query = 'jose'
        special_client = Client.new(id: 5, full_name: 'José María', email: 'jose@example.com')
        matching_clients = [special_client]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   Name: José María')
      end

      it 'displays client email detail for special character client' do
        query = 'jose'
        special_client = Client.new(id: 5, full_name: 'José María', email: 'jose@example.com')
        matching_clients = [special_client]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   Email: jose@example.com')
      end

      it 'displays client id detail for special character client' do
        query = 'jose'
        special_client = Client.new(id: 5, full_name: 'José María', email: 'jose@example.com')
        matching_clients = [special_client]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include('   ID: 5')
      end

      it 'displays search header for special character query' do
        query = 'test@123'
        matching_clients = [john_doe]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include("🔍 Searching for: '#{query}'")
      end

      it 'displays found summary for special character query' do
        query = 'test@123'
        matching_clients = [john_doe]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include("✅ Found 1 client(s) matching '#{query}':")
      end

      it 'displays search header for empty query' do
        query = ''
        matching_clients = [john_doe]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include("🔍 Searching for: ''")
      end

      it 'displays found summary for empty query' do
        query = ''
        matching_clients = [john_doe]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include("✅ Found 1 client(s) matching '':")
      end

      it 'displays search header for query with spaces' do
        query = 'john doe'
        matching_clients = [john_doe]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include("🔍 Searching for: '#{query}'")
      end

      it 'displays found summary for query with spaces' do
        query = 'john doe'
        matching_clients = [john_doe]

        result = described_class.show_search_results(matching_clients, query)

        expect(result).to include("✅ Found 1 client(s) matching '#{query}':")
      end
    end
  end
end
