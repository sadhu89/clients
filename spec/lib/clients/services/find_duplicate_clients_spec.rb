# frozen_string_literal: true

require_relative '../../../../lib/clients/models/client'
require_relative '../../../../lib/clients/services/find_duplicate_clients'

RSpec.describe FindDuplicateClients do
  let(:sample_clients) do
    [
      Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com'),
      Client.new(id: 2, full_name: 'Jane Smith', email: 'jane@example.com'),
      Client.new(id: 3, full_name: 'Bob Johnson', email: 'bob@example.com'),
      Client.new(id: 4, full_name: 'Alice Brown', email: 'john@example.com'),
      Client.new(id: 5, full_name: 'Charlie Wilson', email: 'jane@example.com'),
      Client.new(id: 6, full_name: 'David Lee', email: nil),
      Client.new(id: 7, full_name: 'Eve Davis', email: nil),
      Client.new(id: 8, full_name: 'Frank Miller', email: ''),
      Client.new(id: 9, full_name: 'Grace Taylor', email: '')
    ]
  end

  describe '.call' do
    context 'when there are duplicate emails' do
      it 'finds clients with duplicate email addresses' do
        result = FindDuplicateClients.call(sample_clients)

        expect(result).to have_key('john@example.com')
        expect(result).to have_key('jane@example.com')
        expect(result['john@example.com'].length).to eq(2)
        expect(result['jane@example.com'].length).to eq(2)
      end

      it 'groups clients by email address (case insensitive)' do
        clients_with_case_variations = [
          Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com'),
          Client.new(id: 2, full_name: 'Jane Smith', email: 'JOHN@EXAMPLE.COM'),
          Client.new(id: 3, full_name: 'Bob Johnson', email: 'John@Example.com')
        ]

        result = FindDuplicateClients.call(clients_with_case_variations)

        expect(result).to have_key('john@example.com')
        expect(result['john@example.com'].length).to eq(3)
      end

      it 'includes all clients with the same email in the group' do
        result = FindDuplicateClients.call(sample_clients)

        john_clients = result['john@example.com']
        expect(john_clients.map(&:id)).to contain_exactly(1, 4)
        expect(john_clients.map(&:full_name)).to contain_exactly('John Doe', 'Alice Brown')
      end
    end

    context 'when there are no duplicate emails' do
      it 'returns empty hash when no duplicates exist' do
        unique_clients = [
          Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com'),
          Client.new(id: 2, full_name: 'Jane Smith', email: 'jane@example.com'),
          Client.new(id: 3, full_name: 'Bob Johnson', email: 'bob@example.com')
        ]

        result = FindDuplicateClients.call(unique_clients)
        expect(result).to be_empty
      end
    end

    context 'when dealing with nil and empty emails' do
      it 'handles clients with nil email addresses' do
        result = FindDuplicateClients.call(sample_clients)

        expect(result).to have_key(nil)
        expect(result[nil].length).to eq(2)
        expect(result[nil].map(&:id)).to contain_exactly(6, 7)
      end

      it 'handles clients with empty email addresses' do
        result = FindDuplicateClients.call(sample_clients)

        expect(result).to have_key('')
        expect(result[''].length).to eq(2)
        expect(result[''].map(&:id)).to contain_exactly(8, 9)
      end

      it 'treats nil and empty emails as different values' do
        result = FindDuplicateClients.call(sample_clients)

        expect(result).to have_key(nil)
        expect(result).to have_key('')
        expect(result[nil].length).to eq(2)
        expect(result[''].length).to eq(2)
      end
    end

    context 'when dealing with edge cases' do
      it 'handles empty client list' do
        result = FindDuplicateClients.call([])
        expect(result).to be_empty
      end

      it 'handles single client' do
        single_client = [Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com')]
        result = FindDuplicateClients.call(single_client)
        expect(result).to be_empty
      end

      it 'handles clients with special characters in emails' do
        special_clients = [
          Client.new(id: 1, full_name: 'John Doe', email: 'john+tag@example.com'),
          Client.new(id: 2, full_name: 'Jane Smith', email: 'john+tag@example.com'),
          Client.new(id: 3, full_name: 'Bob Johnson', email: 'john.tag@example.com'),
          Client.new(id: 4, full_name: 'Alice Brown', email: 'john.tag@example.com')
        ]

        result = FindDuplicateClients.call(special_clients)

        expect(result).to have_key('john+tag@example.com')
        expect(result).to have_key('john.tag@example.com')
        expect(result['john+tag@example.com'].length).to eq(2)
        expect(result['john.tag@example.com'].length).to eq(2)
      end
    end
  end
end
