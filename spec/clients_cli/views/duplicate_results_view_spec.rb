# frozen_string_literal: true

require_relative '../../../lib/clients_cli/views/duplicate_results_view'
require_relative '../../../lib/clients/models/client'

RSpec.describe DuplicateResultsView do
  let(:john_doe) { Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com') }
  let(:jane_doe) { Client.new(id: 2, full_name: 'Jane Doe', email: 'john@example.com') }
  let(:bob_smith) { Client.new(id: 3, full_name: 'Bob Smith', email: 'bob@example.com') }

  describe '.show_duplicate_results' do
    context 'when no duplicates found' do
      let(:result) { described_class.show_duplicate_results({}) }

      it 'includes search message' do
        expect(result).to include('Searching for duplicate emails')
      end

      it 'includes no duplicates message' do
        expect(result).to include('No duplicate email')
      end
    end

    context 'when duplicates found (one client)' do
      it 'includes duplicate count for one client' do
        single_group = { 'test@example.com' => [john_doe] }
        single_result = described_class.show_duplicate_results(single_group)
        expect(single_result).to include('⚠️  Found 1 email address(es) with duplicates:')
      end

      it 'includes email info for one client' do
        single_group = { 'test@example.com' => [john_doe] }
        single_result = described_class.show_duplicate_results(single_group)
        expect(single_result).to include('📧 test@example.com (1 duplicates)')
      end

      it 'includes client info for one client' do
        single_group = { 'test@example.com' => [john_doe] }
        single_result = described_class.show_duplicate_results(single_group)
        expect(single_result).to include('   • John Doe (ID: 1)')
      end
    end

    context 'when duplicates found (multiple clients)' do
      it 'includes duplicate count for multiple clients' do
        alice_johnson = Client.new(id: 4, full_name: 'Alice Johnson', email: 'john@example.com')
        multi_group = { 'john@example.com' => [john_doe, jane_doe, alice_johnson] }
        multi_result = described_class.show_duplicate_results(multi_group)
        expect(multi_result).to include('⚠️  Found 1 email address(es) with duplicates:')
      end

      it 'includes email info for multiple clients' do
        alice_johnson = Client.new(id: 4, full_name: 'Alice Johnson', email: 'john@example.com')
        multi_group = { 'john@example.com' => [john_doe, jane_doe, alice_johnson] }
        multi_result = described_class.show_duplicate_results(multi_group)
        expect(multi_result).to include('📧 john@example.com (3 duplicates)')
      end

      it 'includes first client info for multiple clients' do
        alice_johnson = Client.new(id: 4, full_name: 'Alice Johnson', email: 'john@example.com')
        multi_group = { 'john@example.com' => [john_doe, jane_doe, alice_johnson] }
        multi_result = described_class.show_duplicate_results(multi_group)
        expect(multi_result).to include('   • John Doe (ID: 1)')
      end

      it 'includes second client info for multiple clients' do
        alice_johnson = Client.new(id: 4, full_name: 'Alice Johnson', email: 'john@example.com')
        multi_group = { 'john@example.com' => [john_doe, jane_doe, alice_johnson] }
        multi_result = described_class.show_duplicate_results(multi_group)
        expect(multi_result).to include('   • Jane Doe (ID: 2)')
      end

      it 'includes third client info for multiple clients' do
        alice_johnson = Client.new(id: 4, full_name: 'Alice Johnson', email: 'john@example.com')
        multi_group = { 'john@example.com' => [john_doe, jane_doe, alice_johnson] }
        multi_result = described_class.show_duplicate_results(multi_group)
        expect(multi_result).to include('   • Alice Johnson (ID: 4)')
      end
    end

    context 'when handling edge cases' do
      it 'includes email info for empty name client' do
        empty_name_client = Client.new(id: 5, full_name: '', email: 'empty@example.com')
        empty_group = { 'empty@example.com' => [empty_name_client] }
        empty_result = described_class.show_duplicate_results(empty_group)
        expect(empty_result).to include('📧 empty@example.com (1 duplicates)')
      end

      it 'includes client info for empty name client' do
        empty_name_client = Client.new(id: 5, full_name: '', email: 'empty@example.com')
        empty_group = { 'empty@example.com' => [empty_name_client] }
        empty_result = described_class.show_duplicate_results(empty_group)
        expect(empty_result).to include('   •  (ID: 5)')
      end

      it 'includes email info for special character client' do
        special_client = Client.new(id: 6, full_name: 'José María', email: 'jose@example.com')
        special_group = { 'jose@example.com' => [special_client] }
        special_result = described_class.show_duplicate_results(special_group)
        expect(special_result).to include('📧 jose@example.com (1 duplicates)')
      end

      it 'includes client info for special character client' do
        special_client = Client.new(id: 6, full_name: 'José María', email: 'jose@example.com')
        special_group = { 'jose@example.com' => [special_client] }
        special_result = described_class.show_duplicate_results(special_group)
        expect(special_result).to include('   • José María (ID: 6)')
      end
    end
  end
end
