# frozen_string_literal: true

require_relative '../../../lib/clients_cli/views/search_results_view'
require_relative '../../../lib/clients/models/client'

RSpec.describe SearchResultsView do
  let(:client1) { Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com') }
  let(:client2) { Client.new(id: 2, full_name: 'Jane Smith', email: 'jane@example.com') }
  let(:client3) { Client.new(id: 3, full_name: 'Bob Johnson', email: 'bob@example.com') }

  describe '.show_search_results' do
    context 'when no results found' do
      it 'displays no results message' do
        query = 'nonexistent'
        result = SearchResultsView.show_search_results([], query)
        expect(result).to include('Searching for:')
        expect(result).to include('No clients found')
      end
    end

    context 'when results found' do
      it 'displays search results with correct summary and at least one client' do
        query = 'john'
        matching_clients = [client1, client2]
        result = SearchResultsView.show_search_results(matching_clients, query)
        expect(result).to include('Searching for:')
        expect(result).to include('Found')
        expect(result).to include('John Doe')
      end
    end

    context 'when results found' do
      it 'displays single search result with correct formatting' do
        query = 'john'
        matching_clients = [client1]

        result = SearchResultsView.show_search_results(matching_clients, query)

        expect(result).to include("🔍 Searching for: '#{query}'")
        expect(result).to include("✅ Found 1 client(s) matching '#{query}':")
        expect(result).to include('1. John Doe')
        expect(result).to include('   📧 john@example.com')
        expect(result).to include('   🆔 ID: 1')
        expect(result).to include('   Name: John Doe')
        expect(result).to include('   Email: john@example.com')
        expect(result).to include('   ID: 1')
        expect(result).to include('-' * 40)
      end

      it 'displays multiple search results with correct numbering' do
        query = 'doe'
        matching_clients = [client1, client2]

        result = SearchResultsView.show_search_results(matching_clients, query)

        expect(result).to include("🔍 Searching for: '#{query}'")
        expect(result).to include("✅ Found 2 client(s) matching '#{query}':")
        expect(result).to include('1. John Doe')
        expect(result).to include('2. Jane Smith')
        expect(result).to include('   📧 john@example.com')
        expect(result).to include('   📧 jane@example.com')
        expect(result).to include('   🆔 ID: 1')
        expect(result).to include('   🆔 ID: 2')
      end

      it 'handles clients with empty names' do
        query = 'test'
        empty_name_client = Client.new(id: 4, full_name: '', email: 'test@example.com')
        matching_clients = [empty_name_client]

        result = SearchResultsView.show_search_results(matching_clients, query)

        expect(result).to include('1. ')
        expect(result).to include('   📧 test@example.com')
        expect(result).to include('   🆔 ID: 4')
        expect(result).to include('   Name: ')
        expect(result).to include('   Email: test@example.com')
        expect(result).to include('   ID: 4')
      end

      it 'handles clients with special characters' do
        query = 'jose'
        special_client = Client.new(id: 5, full_name: 'José María', email: 'jose@example.com')
        matching_clients = [special_client]

        result = SearchResultsView.show_search_results(matching_clients, query)

        expect(result).to include('1. José María')
        expect(result).to include('   📧 jose@example.com')
        expect(result).to include('   🆔 ID: 5')
        expect(result).to include('   Name: José María')
        expect(result).to include('   Email: jose@example.com')
        expect(result).to include('   ID: 5')
      end
    end

    context 'edge cases' do
      it 'handles query with special characters' do
        query = 'test@123'
        matching_clients = [client1]

        result = SearchResultsView.show_search_results(matching_clients, query)

        expect(result).to include("🔍 Searching for: '#{query}'")
        expect(result).to include("✅ Found 1 client(s) matching '#{query}':")
      end

      it 'handles empty query' do
        query = ''
        matching_clients = [client1]

        result = SearchResultsView.show_search_results(matching_clients, query)

        expect(result).to include("🔍 Searching for: ''")
        expect(result).to include("✅ Found 1 client(s) matching '':")
      end

      it 'handles query with spaces' do
        query = 'john doe'
        matching_clients = [client1]

        result = SearchResultsView.show_search_results(matching_clients, query)

        expect(result).to include("🔍 Searching for: '#{query}'")
        expect(result).to include("✅ Found 1 client(s) matching '#{query}':")
      end
    end
  end
end
