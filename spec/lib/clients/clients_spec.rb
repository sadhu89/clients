# frozen_string_literal: true

require_relative '../../../lib/clients/clients'
require_relative '../../../lib/clients/models/client'

RSpec.describe Clients do
  let(:test_file_path) { 'spec/fixtures/test_clients.json' }
  let(:sample_clients) do
    [
      Client.new(id: 1, full_name: 'John Doe', email: 'john@example.com'),
      Client.new(id: 2, full_name: 'Jane Smith', email: 'jane@example.com'),
      Client.new(id: 3, full_name: 'Bob Johnson', email: 'bob@example.com')
    ]
  end

  before do
    # Clear the cached clients
    Clients.instance_variable_set(:@clients_cache, nil)
  end

  describe '.all' do
    it 'loads clients from the specified file path' do
      allow(LoadData).to receive(:call).with(test_file_path).and_return(Dry::Monads::Success(sample_clients))

      result = Clients.all(test_file_path)

      expect(result).to be_success
      expect(result.value!).to eq(sample_clients)
    end

    it 'caches the loaded clients' do
      allow(LoadData).to receive(:call).with(test_file_path).and_return(Dry::Monads::Success(sample_clients))

      # First call should load data
      Clients.all(test_file_path)

      # Second call should use cached data
      Clients.all(test_file_path)

      expect(LoadData).to have_received(:call).with(test_file_path).once
    end

    it 'propagates failures from LoadData' do
      error = ClientsSearchError.new('File not found')
      allow(LoadData).to receive(:call).with(test_file_path).and_return(Dry::Monads::Failure(error))

      result = Clients.all(test_file_path)

      expect(result).to be_failure
      expect(result.failure).to eq(error)
    end
  end

  describe '.search' do
    it 'searches for clients matching the query' do
      allow(LoadData).to receive(:call).with(test_file_path).and_return(Dry::Monads::Success(sample_clients))
      allow(FindClients).to receive(:call).with(sample_clients, 'john').and_return([sample_clients.first])

      result = Clients.search(test_file_path, 'john')

      expect(result).to be_success
      expect(result.value!).to eq([sample_clients.first])
      expect(FindClients).to have_received(:call).with(sample_clients, 'john')
    end

    it 'propagates failures from LoadData' do
      error = ClientsSearchError.new('File not found')
      allow(LoadData).to receive(:call).with(test_file_path).and_return(Dry::Monads::Failure(error))

      result = Clients.search(test_file_path, 'john')

      expect(result).to be_failure
      expect(result.failure).to eq(error)
    end
  end

  describe '.find_duplicates' do
    it 'finds duplicate clients' do
      allow(LoadData).to receive(:call).with(test_file_path).and_return(Dry::Monads::Success(sample_clients))
      duplicate_groups = { 'john@example.com' => [sample_clients.first] }
      allow(FindDuplicateClients).to receive(:call).with(sample_clients).and_return(duplicate_groups)

      result = Clients.find_duplicates(test_file_path)

      expect(result).to be_success
      expect(result.value!).to eq(duplicate_groups)
      expect(FindDuplicateClients).to have_received(:call).with(sample_clients)
    end

    it 'propagates failures from LoadData' do
      error = ClientsSearchError.new('File not found')
      allow(LoadData).to receive(:call).with(test_file_path).and_return(Dry::Monads::Failure(error))

      result = Clients.find_duplicates(test_file_path)

      expect(result).to be_failure
      expect(result.failure).to eq(error)
    end
  end
end
