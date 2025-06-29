# frozen_string_literal: true

require_relative '../../../../lib/clients/services/load_data'
require_relative '../../../../lib/clients/models/client'

RSpec.describe LoadData do
  let(:valid_json_file) { 'spec/fixtures/valid_clients.json' }
  let(:invalid_json_file) { 'spec/fixtures/invalid_clients.json' }
  let(:nonexistent_file) { 'spec/fixtures/nonexistent.json' }
  let(:invalid_data_file) { 'spec/fixtures/invalid_data_clients.json' }

  let(:valid_clients_data) do
    [
      { 'id' => 1, 'full_name' => 'John Doe', 'email' => 'john@example.com' },
      { 'id' => 2, 'full_name' => 'Jane Smith', 'email' => 'jane@example.com' }
    ]
  end

  before do
    # Create test fixtures
    File.write(valid_json_file, valid_clients_data.to_json)
    File.write(invalid_json_file, 'invalid json content')
    File.write(invalid_data_file, '[{"id": "not_an_integer"}]')
  end

  after do
    # Clean up test fixtures
    FileUtils.rm_f(valid_json_file)
    FileUtils.rm_f(invalid_json_file)
    FileUtils.rm_f(invalid_data_file)
  end

  describe '.call' do
    it 'loads valid client data from JSON file' do
      result = LoadData.call(valid_json_file)

      expect(result).to be_success
      expect(result.value!).to be_an(Array)
      expect(result.value!.length).to eq(2)
      expect(result.value!.first).to be_a(Client)
      expect(result.value!.first.id).to eq(1)
      expect(result.value!.first.full_name).to eq('John Doe')
      expect(result.value!.first.email).to eq('john@example.com')
    end

    it 'returns failure when file does not exist' do
      result = LoadData.call(nonexistent_file)

      expect(result).to be_failure
      expect(result.failure).to be_a(ClientsSearchError)
      expect(result.failure.message).to include('File not found')
    end

    it 'returns failure when JSON is invalid' do
      result = LoadData.call(invalid_json_file)

      expect(result).to be_failure
      expect(result.failure).to be_a(ClientsSearchError)
      expect(result.failure.message).to include('Invalid JSON')
    end

    it 'returns failure when client data is invalid' do
      result = LoadData.call(invalid_data_file)

      expect(result).to be_failure
      expect(result.failure).to be_a(ClientsSearchError)
      expect(result.failure.message).to include('Invalid client data')
    end

    it 'handles empty JSON array' do
      empty_file = 'spec/fixtures/empty_clients.json'
      File.write(empty_file, '[]')

      result = LoadData.call(empty_file)
      expect(result).to be_success
      expect(result.value!).to eq([])

      File.delete(empty_file)
    end

    it 'handles clients with missing optional fields' do
      partial_data_file = 'spec/fixtures/partial_clients.json'
      partial_data = [
        { 'id' => 1, 'full_name' => 'John Doe' },
        { 'id' => 2, 'email' => 'jane@example.com' }
      ]
      File.write(partial_data_file, partial_data.to_json)

      result = LoadData.call(partial_data_file)

      expect(result).to be_success
      expect(result.value!.first.email).to eq('')
      expect(result.value!.last.full_name).to eq('')

      File.delete(partial_data_file)
    end

    it 'handles file read errors' do
      # Create a file that will cause a read error
      unreadable_file = 'spec/fixtures/unreadable_clients.json'
      File.write(unreadable_file, 'test')
      File.chmod(0o000, unreadable_file) # Make file unreadable

      result = LoadData.call(unreadable_file)

      expect(result).to be_failure
      expect(result.failure).to be_a(ClientsSearchError)
      expect(result.failure.message).to include('Cannot read file')

      # Restore permissions for cleanup
      File.chmod(0o644, unreadable_file)
      File.delete(unreadable_file)
    end
  end
end
