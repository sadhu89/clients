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
    described_class.instance_variable_set(:@cache, nil)
  end

  describe '.all' do
    before do
      allow(LoadData).to receive(:call).with(test_file_path).and_return(Dry::Monads::Success(sample_clients))
    end

    it 'returns success' do
      result = described_class.all(test_file_path)
      expect(result).to be_success
    end

    it 'returns correct value' do
      result = described_class.all(test_file_path)
      expect(result.value!).to eq(sample_clients)
    end

    it 'caches the loaded clients' do
      described_class.all(test_file_path)
      described_class.all(test_file_path)
      expect(LoadData).to have_received(:call).with(test_file_path).once
    end

    context 'when LoadData fails' do
      let(:error) { StandardError.new('File not found') }

      before do
        allow(LoadData).to receive(:call)
          .with(test_file_path)
          .and_return(Dry::Monads::Failure(error))
      end

      it 'returns failure' do
        fail_result = described_class.all(test_file_path)
        expect(fail_result).to be_failure
      end

      it 'returns correct error' do
        fail_result = described_class.all(test_file_path)
        expect(fail_result.failure).to eq(error)
      end
    end
  end

  describe '.search' do
    before do
      allow(LoadData).to receive(:call).with(test_file_path).and_return(Dry::Monads::Success(sample_clients))
      allow(FindClients).to receive(:call).with(sample_clients, 'john').and_return([sample_clients.first])
    end

    it 'returns success' do
      result = described_class.search(test_file_path, 'john')
      expect(result).to be_success
    end

    it 'returns correct value' do
      result = described_class.search(test_file_path, 'john')
      expect(result.value!).to eq([sample_clients.first])
    end

    it 'calls FindClients with correct args' do
      described_class.search(test_file_path, 'john')
      expect(FindClients).to have_received(:call).with(sample_clients, 'john')
    end

    context 'when LoadData fails' do
      let(:error) { StandardError.new('File not found') }

      before do
        allow(LoadData).to receive(:call)
          .with(test_file_path)
          .and_return(Dry::Monads::Failure(error))
      end

      it 'returns failure' do
        fail_result = described_class.search(test_file_path, 'john')
        expect(fail_result).to be_failure
      end

      it 'returns correct error' do
        fail_result = described_class.search(test_file_path, 'john')
        expect(fail_result.failure).to eq(error)
      end
    end
  end

  describe '.find_duplicates' do
    before do
      allow(LoadData).to receive(:call).with(test_file_path).and_return(Dry::Monads::Success(sample_clients))
      allow(FindDuplicateClients).to receive(:call)
        .with(sample_clients)
        .and_return({ 'john@example.com' => [sample_clients.first] })
    end

    it 'returns success' do
      result = described_class.find_duplicates(test_file_path)
      expect(result).to be_success
    end

    it 'returns correct value' do
      result = described_class.find_duplicates(test_file_path)
      expect(result.value!).to eq({ 'john@example.com' => [sample_clients.first] })
    end

    it 'calls FindDuplicateClients with correct args' do
      described_class.find_duplicates(test_file_path)
      expect(FindDuplicateClients).to have_received(:call).with(sample_clients)
    end

    context 'when LoadData fails' do
      let(:error) { StandardError.new('File not found') }

      before do
        allow(LoadData).to receive(:call)
          .with(test_file_path)
          .and_return(Dry::Monads::Failure(error))
      end

      it 'returns failure' do
        fail_result = described_class.find_duplicates(test_file_path)
        expect(fail_result).to be_failure
      end

      it 'returns correct error' do
        fail_result = described_class.find_duplicates(test_file_path)
        expect(fail_result.failure).to eq(error)
      end
    end
  end
end
