# frozen_string_literal: true

require_relative '../../../../lib/clients/models/client'

RSpec.describe Client do
  describe 'attributes' do
    it 'has required id attribute' do
      client = described_class.new(id: 1)
      expect(client.id).to eq(1)
    end

    it 'has optional full_name attribute with default empty string' do
      client = described_class.new(id: 1)
      expect(client.full_name).to eq('')
    end

    it 'has optional email attribute with default empty string' do
      client = described_class.new(id: 1)
      expect(client.email).to eq('')
    end

    context 'when created with all attributes' do
      let(:client) { described_class.new(id: 1, full_name: 'John Doe', email: 'john@example.com') }

      it('has correct id') { expect(client.id).to eq(1) }
      it('has correct full_name') { expect(client.full_name).to eq('John Doe') }
      it('has correct email') { expect(client.email).to eq('john@example.com') }
    end
  end

  describe '.from_hash' do
    context 'with string keys' do
      let(:hash) { { 'id' => 1, 'full_name' => 'Jane Doe', 'email' => 'jane@example.com' } }
      let(:client) { described_class.from_hash(hash) }

      it('has correct id') { expect(client.id).to eq(1) }
      it('has correct full_name') { expect(client.full_name).to eq('Jane Doe') }
      it('has correct email') { expect(client.email).to eq('jane@example.com') }
    end

    context 'with missing full_name' do
      let(:hash) { { 'id' => 1, 'email' => 'test@example.com' } }
      let(:client) { described_class.from_hash(hash) }

      it('defaults full_name to empty string') { expect(client.full_name).to eq('') }
    end

    context 'with missing email' do
      let(:hash) { { 'id' => 1, 'full_name' => 'Test User' } }
      let(:client) { described_class.from_hash(hash) }

      it('defaults email to empty string') { expect(client.email).to eq('') }
    end

    context 'with nil values' do
      let(:hash) { { 'id' => 1, 'full_name' => nil, 'email' => nil } }
      let(:client) { described_class.from_hash(hash) }

      it('defaults full_name to empty string') { expect(client.full_name).to eq('') }
      it('defaults email to empty string') { expect(client.email).to eq('') }
    end
  end

  describe '.from_json_array' do
    context 'with valid array' do
      let(:json_array) do
        [
          { 'id' => 1, 'full_name' => 'Alice', 'email' => 'alice@example.com' },
          { 'id' => 2, 'full_name' => 'Bob', 'email' => 'bob@example.com' }
        ]
      end
      let(:clients) { described_class.from_json_array(json_array) }

      it('returns array') { expect(clients).to be_an(Array) }
      it('returns correct length') { expect(clients.length).to eq(2) }
      it('first is a Client') { expect(clients.first).to be_a(described_class) }
      it('first id') { expect(clients.first.id).to eq(1) }
      it('first full_name') { expect(clients.first.full_name).to eq('Alice') }
      it('first email') { expect(clients.first.email).to eq('alice@example.com') }
      it('last id') { expect(clients.last.id).to eq(2) }
      it('last full_name') { expect(clients.last.full_name).to eq('Bob') }
      it('last email') { expect(clients.last.email).to eq('bob@example.com') }
    end

    it 'returns empty array for empty json array' do
      clients = described_class.from_json_array([])
      expect(clients).to eq([])
    end

    context 'with missing optional fields' do
      let(:json_array) { [{ 'id' => 1 }, { 'id' => 2, 'full_name' => 'Test' }] }
      let(:clients) { described_class.from_json_array(json_array) }

      it('first full_name defaults to empty string') { expect(clients.first.full_name).to eq('') }
      it('first email defaults to empty string') { expect(clients.first.email).to eq('') }
      it('last full_name is Test') { expect(clients.last.full_name).to eq('Test') }
      it('last email defaults to empty string') { expect(clients.last.email).to eq('') }
    end
  end

  describe 'type validation' do
    it 'requires id to be an integer' do
      expect { described_class.new(id: '1') }.to raise_error(Dry::Struct::Error)
    end

    it 'allows full_name to be optional' do
      expect { described_class.new(id: 1, full_name: nil) }.not_to raise_error
    end

    it 'allows email to be optional' do
      expect { described_class.new(id: 1, email: nil) }.not_to raise_error
    end
  end
end
