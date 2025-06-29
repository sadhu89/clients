require 'spec_helper'
require_relative '../../lib/client_duplicates'

RSpec.describe FindDuplicateClients do
  let(:sample_clients) do
    [
      { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john.doe@example.com' },
      { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane.smith@example.com' },
      { 'id' => 3, 'full_name' => 'Alex Johnson', 'email' => 'alex.johnson@example.com' },
      { 'id' => 4, 'full_name' => 'Michael Williams', 'email' => 'michael.williams@example.com' },
      { 'id' => 5, 'full_name' => 'Another Jane Smith', 'email' => 'jane.smith2@example.com' }
    ]
  end

  describe '.call' do
    context 'when there are duplicate emails' do
      let(:clients_with_duplicates) do
        [
          { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john.doe@example.com' },
          { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane.smith@example.com' },
          { 'id' => 3, 'full_name' => 'Alex Johnson', 'email' => 'alex.johnson@example.com' },
          { 'id' => 4, 'full_name' => 'Another Jane Smith', 'email' => 'jane.smith@example.com' },
          { 'id' => 5, 'full_name' => 'John Doe Jr', 'email' => 'john.doe@example.com' },
          { 'id' => 6, 'full_name' => 'Unique Person', 'email' => 'unique@example.com' }
        ]
      end

      it 'finds all duplicate email addresses' do
        result = FindDuplicateClients.call(clients_with_duplicates)
        expect(result.keys).to contain_exactly('john.doe@example.com', 'jane.smith@example.com')
      end

      it 'groups clients by duplicate email addresses' do
        result = FindDuplicateClients.call(clients_with_duplicates)
        
        expect(result['john.doe@example.com']).to contain_exactly(
          { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john.doe@example.com' },
          { 'id' => 5, 'full_name' => 'John Doe Jr', 'email' => 'john.doe@example.com' }
        )
        
        expect(result['jane.smith@example.com']).to contain_exactly(
          { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane.smith@example.com' },
          { 'id' => 4, 'full_name' => 'Another Jane Smith', 'email' => 'jane.smith@example.com' }
        )
      end

      it 'handles case-insensitive email matching' do
        clients_with_case_variations = [
          { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john.doe@example.com' },
          { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'JOHN.DOE@EXAMPLE.COM' },
          { 'id' => 3, 'full_name' => 'Alex Johnson', 'email' => 'John.Doe@Example.com' }
        ]
        
        result = FindDuplicateClients.call(clients_with_case_variations)
        expect(result.keys).to contain_exactly('john.doe@example.com')
        expect(result['john.doe@example.com'].length).to eq(3)
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
          { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john@example.com' },
          { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => nil },
          { 'id' => 3, 'full_name' => 'Alex Johnson', 'email' => nil }
        ]
        
        result = FindDuplicateClients.call(clients_with_nil_emails)
        expect(result.keys).to contain_exactly(nil)
        expect(result[nil].length).to eq(2)
      end

      it 'handles empty email addresses' do
        clients_with_empty_emails = [
          { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john@example.com' },
          { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => '' },
          { 'id' => 3, 'full_name' => 'Alex Johnson', 'email' => '' }
        ]
        
        result = FindDuplicateClients.call(clients_with_empty_emails)
        expect(result.keys).to contain_exactly('')
        expect(result[''].length).to eq(2)
      end

      it 'handles empty clients array' do
        result = FindDuplicateClients.call([])
        expect(result).to eq({})
      end

      it 'handles single client' do
        single_client = [{ 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john@example.com' }]
        result = FindDuplicateClients.call(single_client)
        expect(result).to eq({})
      end
    end
  end
end 
