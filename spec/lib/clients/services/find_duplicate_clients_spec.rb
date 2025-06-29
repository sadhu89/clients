require_relative '../../../../lib/clients/models/client'
require_relative '../../../../lib/clients/services/find_duplicate_clients'

RSpec.describe FindDuplicateClients do
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
    context 'when there are duplicate emails' do
      let(:clients_with_duplicates) do
        [
          Client.new(id: 1, full_name: 'John Doe', email: 'john.doe@example.com'),
          Client.new(id: 2, full_name: 'Jane Smith', email: 'jane.smith@example.com'),
          Client.new(id: 3, full_name: 'Alex Johnson', email: 'alex.johnson@example.com'),
          Client.new(id: 4, full_name: 'Another Jane Smith', email: 'jane.smith@example.com'),
          Client.new(id: 5, full_name: 'John Doe Jr', email: 'john.doe@example.com'),
          Client.new(id: 6, full_name: 'Unique Person', email: 'unique@example.com')
        ]
      end

      it 'finds all duplicate email addresses' do
        result = FindDuplicateClients.call(clients_with_duplicates)
        expect(result.keys).to contain_exactly('john.doe@example.com', 'jane.smith@example.com')
      end

      it 'groups clients by duplicate email addresses' do
        result = FindDuplicateClients.call(clients_with_duplicates)
        
        expect(result['john.doe@example.com']).to contain_exactly(
          clients_with_duplicates[0], # John Doe
          clients_with_duplicates[4]  # John Doe Jr
        )
        
        expect(result['jane.smith@example.com']).to contain_exactly(
          clients_with_duplicates[1], # Jane Smith
          clients_with_duplicates[3]  # Another Jane Smith
        )
      end

      it 'handles case-insensitive email matching' do
        clients_with_case_variations = [
          Client.new(id: 1, full_name: 'John Doe', email: 'john.doe@example.com'),
          Client.new(id: 2, full_name: 'Jane Smith', email: 'JOHN.DOE@EXAMPLE.COM'),
          Client.new(id: 3, full_name: 'Alex Johnson', email: 'John.Doe@Example.com')
        ]
        
        result = FindDuplicateClients.call(clients_with_case_variations)
        expect(result.keys).to contain_exactly('john.doe@example.com')
        expect(result['john.doe@example.com']).to contain_exactly(
          clients_with_case_variations[0],
          clients_with_case_variations[1], 
          clients_with_case_variations[2]
        )
      end
    end

    context 'when there are no duplicate emails' do
      it 'returns empty hash when no duplicates exist' do
        result = FindDuplicateClients.call(sample_clients)
        expect(result).to eq({})
      end
    end

    context 'when dealing with edge cases' do
      it 'handles nil email addresses' do
        clients_with_nil_emails = [
          Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com'),
          Client.new(id: 2, full_name: 'Jane Smith', email: nil),
          Client.new(id: 3, full_name: 'Alex Johnson', email: nil)
        ]
        
        result = FindDuplicateClients.call(clients_with_nil_emails)
        expect(result.keys).to contain_exactly(nil)
        expect(result[nil]).to contain_exactly(clients_with_nil_emails[1], clients_with_nil_emails[2])
      end

      it 'handles empty email addresses' do
        clients_with_empty_emails = [
          Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com'),
          Client.new(id: 2, full_name: 'Jane Smith', email: ''),
          Client.new(id: 3, full_name: 'Alex Johnson', email: '')
        ]
        
        result = FindDuplicateClients.call(clients_with_empty_emails)
        expect(result.keys).to contain_exactly('')
        expect(result['']).to contain_exactly(clients_with_empty_emails[1], clients_with_empty_emails[2])
      end

      it 'handles empty clients array' do
        result = FindDuplicateClients.call([])
        expect(result).to eq({})
      end

      it 'handles single client' do
        single_client = [Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com')]
        result = FindDuplicateClients.call(single_client)
        expect(result).to eq({})
      end
    end
  end
end 
