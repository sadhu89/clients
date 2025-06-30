# frozen_string_literal: true

require_relative '../../../../lib/clients/services/load_data'
require_relative '../../../../lib/clients/models/client'

RSpec.describe LoadData do
  describe '.call' do
    context 'with valid client data' do
      let(:valid_json_file) { 'spec/fixtures/test_clients.json' }

      it 'returns success' do
        result = described_class.call(valid_json_file)
        expect(result).to be_success
      end

      it 'returns an array' do
        result = described_class.call(valid_json_file)
        expect(result.value!).to be_an(Array)
      end

      it 'returns correct length' do
        result = described_class.call(valid_json_file)
        expect(result.value!.length).to eq(6)
      end

      it 'first is a Client' do
        result = described_class.call(valid_json_file)
        expect(result.value!.first).to be_a(Client)
      end

      it 'first id is correct' do
        result = described_class.call(valid_json_file)
        expect(result.value!.first.id).to eq(1)
      end

      it 'first full_name is correct' do
        result = described_class.call(valid_json_file)
        expect(result.value!.first.full_name).to eq('John Doe')
      end

      it 'first email is correct' do
        result = described_class.call(valid_json_file)
        expect(result.value!.first.email).to eq('john@example.com')
      end
    end

    context 'when file does not exist' do
      let(:nonexistent_file) { 'spec/fixtures/nonexistent.json' }

      it 'returns failure' do
        result = described_class.call(nonexistent_file)
        expect(result).to be_failure
      end

      it 'returns string error' do
        result = described_class.call(nonexistent_file)
        expect(result.failure).to be_a(String)
      end

      it 'error includes file not found' do
        result = described_class.call(nonexistent_file)
        expect(result.failure).to include('File not found')
      end
    end

    context 'when JSON is invalid' do
      let(:invalid_json_file) { 'spec/fixtures/invalid_clients.json' }

      it 'returns failure' do
        result = described_class.call(invalid_json_file)
        expect(result).to be_failure
      end

      it 'returns StandardError' do
        result = described_class.call(invalid_json_file)
        expect(result.failure).to be_a(StandardError)
      end

      it 'error message includes unexpected character' do
        result = described_class.call(invalid_json_file)
        expect(result.failure.message).to include('unexpected character')
      end
    end

    context 'when client data is invalid' do
      let(:invalid_data_file) { 'spec/fixtures/invalid_data_clients.json' }

      it 'returns failure' do
        result = described_class.call(invalid_data_file)
        expect(result).to be_failure
      end

      it 'returns StandardError' do
        result = described_class.call(invalid_data_file)
        expect(result.failure).to be_a(StandardError)
      end

      it 'error message includes invalid type' do
        result = described_class.call(invalid_data_file)
        expect(result.failure.message).to include('has invalid type for :id')
      end
    end

    context 'with empty JSON array' do
      it 'returns success' do
        empty_file = 'spec/fixtures/empty_clients.json'
        result = described_class.call(empty_file)
        expect(result).to be_success
      end

      it 'returns empty array' do
        empty_file = 'spec/fixtures/empty_clients.json'
        result = described_class.call(empty_file)
        expect(result.value!).to eq([])
      end
    end

    context 'with missing optional fields' do
      it 'returns success' do
        partial_data_file = 'spec/fixtures/partial_clients.json'
        result = described_class.call(partial_data_file)
        expect(result).to be_success
      end

      it 'first email defaults to empty string' do
        partial_data_file = 'spec/fixtures/partial_clients.json'
        result = described_class.call(partial_data_file)
        expect(result.value!.first.email).to eq('')
      end

      it 'last full_name defaults to empty string' do
        partial_data_file = 'spec/fixtures/partial_clients.json'
        result = described_class.call(partial_data_file)
        expect(result.value!.last.full_name).to eq('')
      end
    end

    context 'when file read errors occur' do
      let(:unreadable_file) { 'spec/fixtures/invalid_clients.json' }

      before do
        allow(File).to receive(:read)
          .with(unreadable_file)
          .and_raise(Errno::EACCES.new('Permission denied'))
      end

      it 'returns failure' do
        result = described_class.call(unreadable_file)
        expect(result).to be_failure
      end

      it 'returns StandardError' do
        result = described_class.call(unreadable_file)
        expect(result.failure).to be_a(StandardError)
      end

      it 'error message includes permission denied' do
        result = described_class.call(unreadable_file)
        expect(result.failure.message).to include('Permission denied')
      end
    end
  end
end
