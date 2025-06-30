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
      let(:result) { described_class.call(sample_clients) }

      it('has john@example.com key') { expect(result).to have_key('john@example.com') }
      it('has jane@example.com key') { expect(result).to have_key('jane@example.com') }
      it('john@example.com group length') { expect(result['john@example.com'].length).to eq(2) }
      it('jane@example.com group length') { expect(result['jane@example.com'].length).to eq(2) }

      it 'includes all clients with the same email in the group (ids)' do
        john_clients = result['john@example.com']
        expect(john_clients.map(&:id)).to contain_exactly(1, 4)
      end

      it 'includes all clients with the same email in the group (names)' do
        john_clients = result['john@example.com']
        expect(john_clients.map(&:full_name)).to contain_exactly('John Doe', 'Alice Brown')
      end
    end

    context 'when grouping is case insensitive' do
      let(:clients_with_case_variations) do
        [
          Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com'),
          Client.new(id: 2, full_name: 'Jane Smith', email: 'JOHN@EXAMPLE.COM'),
          Client.new(id: 3, full_name: 'Bob Johnson', email: 'John@Example.com')
        ]
      end
      let(:case_result) { described_class.call(clients_with_case_variations) }

      it('has john@example.com key') { expect(case_result).to have_key('john@example.com') }
      it('john@example.com group length') { expect(case_result['john@example.com'].length).to eq(3) }
    end

    context 'when there are no duplicate emails' do
      let(:unique_clients) do
        [
          Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com'),
          Client.new(id: 2, full_name: 'Jane Smith', email: 'jane@example.com'),
          Client.new(id: 3, full_name: 'Bob Johnson', email: 'bob@example.com')
        ]
      end

      it 'returns empty hash when no duplicates exist' do
        result = described_class.call(unique_clients)
        expect(result).to be_empty
      end
    end

    context 'when dealing with nil and empty emails' do
      let(:result) { described_class.call(sample_clients) }

      it 'has nil key' do
        expect(result).to have_key(nil)
      end

      it 'nil group length' do
        expect(result[nil].length).to eq(2)
      end

      it 'nil group ids' do
        expect(result[nil].map(&:id)).to contain_exactly(6, 7)
      end

      it 'has empty string key' do
        expect(result).to have_key('')
      end

      it 'empty string group length' do
        expect(result[''].length).to eq(2)
      end

      it 'empty string group ids' do
        expect(result[''].map(&:id)).to contain_exactly(8, 9)
      end
    end

    context 'when dealing with edge cases' do
      it 'handles empty client list' do
        result = described_class.call([])
        expect(result).to be_empty
      end

      it 'handles single client' do
        single_client = [Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com')]
        result = described_class.call(single_client)
        expect(result).to be_empty
      end
    end

    context 'with special character emails' do
      let(:special_clients) do
        [
          Client.new(id: 1, full_name: 'John Doe', email: 'john+tag@example.com'),
          Client.new(id: 2, full_name: 'Jane Smith', email: 'john+tag@example.com'),
          Client.new(id: 3, full_name: 'Bob Johnson', email: 'john.tag@example.com'),
          Client.new(id: 4, full_name: 'Alice Brown', email: 'john.tag@example.com')
        ]
      end
      let(:result) { described_class.call(special_clients) }

      it 'has john+tag@example.com key' do
        expect(result).to have_key('john+tag@example.com')
      end

      it 'john+tag@example.com group length' do
        expect(result['john+tag@example.com'].length).to eq(2)
      end

      it 'has john.tag@example.com key' do
        expect(result).to have_key('john.tag@example.com')
      end

      it 'john.tag@example.com group length' do
        expect(result['john.tag@example.com'].length).to eq(2)
      end
    end
  end
end
