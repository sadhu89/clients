# frozen_string_literal: true

require_relative '../../../../lib/clients/services/find_clients'
require_relative '../../../../lib/clients/models/client'

RSpec.describe FindClients do
  let(:sample_clients) do
    [
      Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com'),
      Client.new(id: 2, full_name: 'Jane Smith', email: 'jane@example.com'),
      Client.new(id: 3, full_name: 'Bob Wilson', email: 'bob@example.com'),
      Client.new(id: 4, full_name: nil, email: 'nil@example.com'),
      Client.new(id: 5, full_name: '', email: 'empty@example.com')
    ]
  end

  describe '.call' do
    context 'when query is nil' do
      it 'returns all clients' do
        result = FindClients.call(sample_clients, nil)
        expect(result).to eq(sample_clients)
      end
    end

    context 'when query is provided' do
      it 'finds clients with matching full names (case insensitive)' do
        result = FindClients.call(sample_clients, 'john')
        expect(result).to contain_exactly(sample_clients[0])
      end

      it 'finds clients with partial name matches' do
        result = FindClients.call(sample_clients, 'doe')
        expect(result).to contain_exactly(sample_clients[0])
      end

      it 'finds multiple clients with matching names' do
        result = FindClients.call(sample_clients, 'j')
        expect(result).to contain_exactly(sample_clients[0], sample_clients[1])
      end

      it 'returns empty array when no matches found' do
        result = FindClients.call(sample_clients, 'xyz')
        expect(result).to be_empty
      end

      it 'handles clients with nil full_name' do
        result = FindClients.call(sample_clients, 'nil')
        expect(result).to be_empty
      end

      it 'handles clients with empty full_name' do
        result = FindClients.call(sample_clients, 'empty')
        expect(result).to be_empty
      end

      it 'handles case insensitive search' do
        result = FindClients.call(sample_clients, 'JOHN')
        expect(result).to contain_exactly(sample_clients[0])
      end

      it 'handles empty query string' do
        result = FindClients.call(sample_clients, '')
        expect(result).to contain_exactly(sample_clients[0], sample_clients[1], sample_clients[2], sample_clients[4])
      end

      it 'handles whitespace in query' do
        result = FindClients.call(sample_clients, '  john  ')
        expect(result).to be_empty
      end
    end

    context 'when searching for existing clients' do
      it 'finds clients with exact name matches' do
        result = FindClients.call(sample_clients, 'John Doe')
        expect(result).to contain_exactly(sample_clients[0])
      end

      it 'finds multiple clients with partial matches' do
        result = FindClients.call(sample_clients, 'j')
        expect(result).to contain_exactly(sample_clients[0], sample_clients[1])
      end

      it 'returns empty array for non-matching queries' do
        result = FindClients.call(sample_clients, 'nonexistent')
        expect(result).to be_empty
      end
    end

    context 'when dealing with edge cases' do
      it 'handles empty clients array' do
        result = FindClients.call([], 'test')
        expect(result).to be_empty
      end

      it 'handles clients with special characters in names' do
        special_clients = [
          Client.new(id: 1, full_name: 'John-Doe', email: 'john@example.com'),
          Client.new(id: 2, full_name: 'Jane_Smith', email: 'jane@example.com')
        ]
        
        result = FindClients.call(special_clients, 'john')
        expect(result).to contain_exactly(special_clients[0])
      end

      it 'handles very long names' do
        long_name_client = Client.new(id: 1, full_name: 'Very Long Name That Goes On And On', email: 'long@example.com')
        result = FindClients.call([long_name_client], 'long')
        expect(result).to contain_exactly(long_name_client)
      end
    end
  end
end
