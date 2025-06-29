# frozen_string_literal: true

require_relative '../../../lib/clients_cli/views/duplicate_results_view'
require_relative '../../../lib/clients/models/client'

RSpec.describe DuplicateResultsView do
  let(:client1) { Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com') }
  let(:client2) { Client.new(id: 2, full_name: 'Jane Doe', email: 'john@example.com') }
  let(:client3) { Client.new(id: 3, full_name: 'Bob Smith', email: 'bob@example.com') }

  describe '.show_duplicate_results' do
    context 'when no duplicates found' do
      it 'displays no duplicates message' do
        result = DuplicateResultsView.show_duplicate_results({})
        expect(result).to include('Searching for duplicate emails')
        expect(result).to include('No duplicate email')
      end
    end

    context 'when duplicates found' do
      it 'displays duplicate results with summary and at least one duplicate' do
        duplicate_groups = {
          'john@example.com' => [client1, client2],
          'bob@example.com' => [client3]
        }
        result = DuplicateResultsView.show_duplicate_results(duplicate_groups)
        expect(result).to include('Searching for duplicate emails')
        expect(result).to include('Found')
        expect(result).to include('john@example.com')
      end

      it 'handles single duplicate group' do
        duplicate_groups = {
          'test@example.com' => [client1]
        }

        result = DuplicateResultsView.show_duplicate_results(duplicate_groups)

        expect(result).to include('⚠️  Found 1 email address(es) with duplicates:')
        expect(result).to include('📧 test@example.com (1 duplicates)')
        expect(result).to include('   • John Doe (ID: 1)')
      end

      it 'handles multiple clients with same email' do
        client4 = Client.new(id: 4, full_name: 'Alice Johnson', email: 'john@example.com')
        duplicate_groups = {
          'john@example.com' => [client1, client2, client4]
        }

        result = DuplicateResultsView.show_duplicate_results(duplicate_groups)

        expect(result).to include('⚠️  Found 1 email address(es) with duplicates:')
        expect(result).to include('📧 john@example.com (3 duplicates)')
        expect(result).to include('   • John Doe (ID: 1)')
        expect(result).to include('   • Jane Doe (ID: 2)')
        expect(result).to include('   • Alice Johnson (ID: 4)')
      end
    end

    context 'edge cases' do
      it 'handles clients with empty names' do
        empty_name_client = Client.new(id: 5, full_name: '', email: 'empty@example.com')
        duplicate_groups = {
          'empty@example.com' => [empty_name_client]
        }

        result = DuplicateResultsView.show_duplicate_results(duplicate_groups)

        expect(result).to include('📧 empty@example.com (1 duplicates)')
        expect(result).to include('   •  (ID: 5)')
      end

      it 'handles clients with special characters in names' do
        special_client = Client.new(id: 6, full_name: 'José María', email: 'jose@example.com')
        duplicate_groups = {
          'jose@example.com' => [special_client]
        }

        result = DuplicateResultsView.show_duplicate_results(duplicate_groups)

        expect(result).to include('📧 jose@example.com (1 duplicates)')
        expect(result).to include('   • José María (ID: 6)')
      end
    end
  end
end
