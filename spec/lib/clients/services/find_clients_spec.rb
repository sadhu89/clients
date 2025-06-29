require_relative '../../../../lib/clients/models/client'
require_relative '../../../../lib/clients/services/find_clients'

RSpec.describe FindClients do
  let(:sample_clients) do
    [
      Client.new(id: 1, full_name: 'John Doe', email: 'john.doe@example.com'),
      Client.new(id: 2, full_name: 'Jane Smith', email: 'jane.smith@example.com'),
      Client.new(id: 3, full_name: 'Alex Johnson', email: 'alex.johnson@example.com'),
      Client.new(id: 4, full_name: 'Michael Williams', email: 'michael.williams@example.com'),
      Client.new(id: 5, full_name: 'Another Jane Smith', email: 'jane.smith2@example.com')
    ]
  end

  describe '.call' do
    context 'when searching for existing clients' do
      it 'finds clients with exact name matches' do
        result = FindClients.call(sample_clients, 'John Doe')
        expect(result).to eq([sample_clients[0]])
      end

      it 'finds clients with partial name matches' do
        result = FindClients.call(sample_clients, 'john')
        expect(result).to eq([sample_clients[0], sample_clients[2]])
      end

      it 'finds multiple clients with partial matches' do
        result = FindClients.call(sample_clients, 'jane')
        expect(result).to eq([sample_clients[1], sample_clients[4]])
      end

      it 'finds clients with case-insensitive matches' do
        result = FindClients.call(sample_clients, 'JOHN')
        expect(result).to eq([sample_clients[0], sample_clients[2]])
      end

      it 'finds clients with mixed case matches' do
        result = FindClients.call(sample_clients, 'John')
        expect(result).to eq([sample_clients[0], sample_clients[2]])
      end
    end

    context 'when searching for non-existent clients' do
      it 'returns empty array for non-matching query' do
        result = FindClients.call(sample_clients, 'nonexistent')
        expect(result).to eq([])
      end

      it 'returns empty array for partial non-matches' do
        result = FindClients.call(sample_clients, 'xyz')
        expect(result).to eq([])
      end
    end

    context 'when searching with empty or nil query' do
      it 'returns all clients when query is empty string' do
        result = FindClients.call(sample_clients, '')
        expect(result).to eq(sample_clients)
      end

      it 'returns all clients when query is nil' do
        result = FindClients.call(sample_clients, nil)
        expect(result).to eq(sample_clients)
      end
    end

    context 'when dealing with edge cases' do
      let(:edge_case_clients) do
        [
          Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com'),
          Client.new(id: 2, full_name: '', email: 'nil@example.com'),
          Client.new(id: 3, full_name: '', email: 'empty@example.com'),
          Client.new(id: 4, full_name: '   John   ', email: 'spaces@example.com')
        ]
      end

      it 'handles empty names gracefully' do
        result = FindClients.call(edge_case_clients, 'john')
        expect(result).to eq([edge_case_clients[0], edge_case_clients[3]])
      end

      it 'handles empty names gracefully' do
        result = FindClients.call(edge_case_clients, 'empty')
        expect(result).to eq([])
      end

      it 'handles names with extra spaces' do
        result = FindClients.call(edge_case_clients, 'john')
        expect(result).to include(edge_case_clients[3])
      end
    end

    context 'when dealing with special characters' do
      let(:special_clients) do
        [
          Client.new(id: 1, full_name: 'José García', email: 'jose@example.com'),
          Client.new(id: 2, full_name: "O'Connor", email: 'oconnor@example.com'),
          Client.new(id: 3, full_name: 'Smith-Jones', email: 'smithjones@example.com')
        ]
      end

      it 'handles accented characters' do
        result = FindClients.call(special_clients, 'josé')
        expect(result).to eq([special_clients[0]])
      end

      it 'handles apostrophes' do
        result = FindClients.call(special_clients, "o'connor")
        expect(result).to eq([special_clients[1]])
      end

      it 'handles hyphens' do
        result = FindClients.call(special_clients, 'smith-jones')
        expect(result).to eq([special_clients[2]])
      end
    end

    context 'when dealing with empty clients data' do
      it 'returns empty array for empty clients data' do
        result = FindClients.call([], 'john')
        expect(result).to eq([])
      end

      it 'returns empty array for empty clients data with empty query' do
        result = FindClients.call([], '')
        expect(result).to eq([])
      end
    end
  end
end 
