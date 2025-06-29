# frozen_string_literal: true

require_relative '../../../../lib/clients/models/client'

RSpec.describe Client do
  describe 'attributes' do
    it 'has required id attribute' do
      client = Client.new(id: 1)
      expect(client.id).to eq(1)
    end

    it 'has optional full_name attribute with default empty string' do
      client = Client.new(id: 1)
      expect(client.full_name).to eq('')
    end

    it 'has optional email attribute with default empty string' do
      client = Client.new(id: 1)
      expect(client.email).to eq('')
    end

    it 'can be created with all attributes' do
      client = Client.new(
        id: 1,
        full_name: 'John Doe',
        email: 'john@example.com'
      )

      expect(client.id).to eq(1)
      expect(client.full_name).to eq('John Doe')
      expect(client.email).to eq('john@example.com')
    end
  end

  describe '.from_hash' do
    it 'creates a client from a hash with string keys' do
      hash = {
        'id' => 1,
        'full_name' => 'Jane Doe',
        'email' => 'jane@example.com'
      }

      client = Client.from_hash(hash)

      expect(client.id).to eq(1)
      expect(client.full_name).to eq('Jane Doe')
      expect(client.email).to eq('jane@example.com')
    end

    it 'handles missing full_name with default empty string' do
      hash = { 'id' => 1, 'email' => 'test@example.com' }
      client = Client.from_hash(hash)

      expect(client.full_name).to eq('')
    end

    it 'handles missing email with default empty string' do
      hash = { 'id' => 1, 'full_name' => 'Test User' }
      client = Client.from_hash(hash)

      expect(client.email).to eq('')
    end

    it 'handles nil values with defaults' do
      hash = {
        'id' => 1,
        'full_name' => nil,
        'email' => nil
      }

      client = Client.from_hash(hash)

      expect(client.full_name).to eq('')
      expect(client.email).to eq('')
    end
  end

  describe '.from_json_array' do
    it 'creates an array of clients from json array' do
      json_array = [
        { 'id' => 1, 'full_name' => 'Alice', 'email' => 'alice@example.com' },
        { 'id' => 2, 'full_name' => 'Bob', 'email' => 'bob@example.com' }
      ]

      clients = Client.from_json_array(json_array)

      expect(clients).to be_an(Array)
      expect(clients.length).to eq(2)
      expect(clients.first).to be_a(Client)
      expect(clients.first.id).to eq(1)
      expect(clients.first.full_name).to eq('Alice')
      expect(clients.first.email).to eq('alice@example.com')
      expect(clients.last.id).to eq(2)
      expect(clients.last.full_name).to eq('Bob')
      expect(clients.last.email).to eq('bob@example.com')
    end

    it 'returns empty array for empty json array' do
      clients = Client.from_json_array([])

      expect(clients).to eq([])
    end

    it 'handles clients with missing optional fields' do
      json_array = [
        { 'id' => 1 },
        { 'id' => 2, 'full_name' => 'Test' }
      ]

      clients = Client.from_json_array(json_array)

      expect(clients.first.full_name).to eq('')
      expect(clients.first.email).to eq('')
      expect(clients.last.full_name).to eq('Test')
      expect(clients.last.email).to eq('')
    end
  end

  describe 'type validation' do
    it 'requires id to be an integer' do
      expect { Client.new(id: '1') }.to raise_error(Dry::Struct::Error)
    end

    it 'allows full_name to be optional' do
      expect { Client.new(id: 1, full_name: nil) }.not_to raise_error
    end

    it 'allows email to be optional' do
      expect { Client.new(id: 1, email: nil) }.not_to raise_error
    end
  end
end
