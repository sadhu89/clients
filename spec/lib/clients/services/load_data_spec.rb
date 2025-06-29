# frozen_string_literal: true

require_relative '../../../../lib/clients/services/load_data'
require_relative '../../../../lib/clients/models/client'

RSpec.describe LoadData do
  let(:valid_json_file) { 'spec/fixtures/test_clients.json' }
  let(:invalid_json_file) { 'spec/fixtures/invalid_clients.json' }
  let(:nonexistent_file) { 'spec/fixtures/nonexistent.json' }
  let(:invalid_data_file) { 'spec/fixtures/invalid_data_clients.json' }

  let(:valid_clients_data) do
    [
      { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john@example.com' },
      { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane@example.com' },
      { 'id' => 3, 'full_name' => 'Bob Johnson', 'email' => 'bob@example.com' }
    ]
  end

  describe '.call' do
    it 'loads valid client data from JSON file' do
      result = LoadData.call(valid_json_file)

      expect(result).to be_success
      expect(result.value!).to be_an(Array)
      expect(result.value!.length).to eq(6)
      expect(result.value!.first).to be_a(Client)
      expect(result.value!.first.id).to eq(1)
      expect(result.value!.first.full_name).to eq('John Doe')
      expect(result.value!.first.email).to eq('john@example.com')
    end

    it 'returns failure when file does not exist' do
      result = LoadData.call(nonexistent_file)

      expect(result).to be_failure
      expect(result.failure).to be_a(String)
      expect(result.failure).to include('File not found')
    end

    it 'returns failure when JSON is invalid' do
      result = LoadData.call(invalid_json_file)

      expect(result).to be_failure
      expect(result.failure).to be_a(StandardError)
      expect(result.failure.message).to include('unexpected character')
    end

    it 'returns failure when client data is invalid' do
      result = LoadData.call(invalid_data_file)

      expect(result).to be_failure
      expect(result.failure).to be_a(StandardError)
      expect(result.failure.message).to include('has invalid type for :id')
    end

    it 'handles empty JSON array' do
      empty_file = 'spec/fixtures/empty_clients.json'

      result = LoadData.call(empty_file)
      expect(result).to be_success
      expect(result.value!).to eq([])
    end

    it 'handles clients with missing optional fields' do
      partial_data_file = 'spec/fixtures/partial_clients.json'

      result = LoadData.call(partial_data_file)

      expect(result).to be_success
      expect(result.value!.first.email).to eq('')
      expect(result.value!.last.full_name).to eq('')
    end

    it 'handles file read errors' do
      # Use the static fixture file
      unreadable_file = 'spec/fixtures/invalid_clients.json'

      # Mock File.read to raise an error
      allow(File).to receive(:read)
        .with(unreadable_file)
        .and_raise(Errno::EACCES.new('Permission denied'))

      result = LoadData.call(unreadable_file)

      expect(result).to be_failure
      expect(result.failure).to be_a(StandardError)
      expect(result.failure.message).to include('Permission denied')
    end
  end
end
