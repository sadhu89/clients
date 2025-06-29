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

      expect(result).to be_an(Array)
      expect(result.length).to eq(2)
      expect(result.first).to be_a(Client)
      expect(result.first.id).to eq(1)
      expect(result.first.full_name).to eq('John Doe')
      expect(result.first.email).to eq('john@example.com')
    end

    it 'raises ClientsSearchError when file does not exist' do
      expect { LoadData.call(nonexistent_file) }.to raise_error(ClientsSearchError, /File not found/)
    end

    it 'raises ClientsSearchError when JSON is invalid' do
      expect { LoadData.call(invalid_json_file) }.to raise_error(ClientsSearchError, /Invalid JSON/)
    end

    it 'raises ClientsSearchError when client data is invalid' do
      expect { LoadData.call(invalid_data_file) }.to raise_error(ClientsSearchError, /Invalid client data/)
    end

    it 'handles empty JSON array' do
      empty_file = 'spec/fixtures/empty_clients.json'
      File.write(empty_file, '[]')

      result = LoadData.call(empty_file)
      expect(result).to eq([])

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

      expect(result.first.email).to eq('')
      expect(result.last.full_name).to eq('')

      File.delete(partial_data_file)
    end
  end
end
