# frozen_string_literal: true

require_relative '../../../../lib/clients/models/types'

RSpec.describe Types do
  describe 'Dry::Types usage' do
    it 'Types::String is a Dry::Types::Type' do
      expect(Types::String).to be_a(Dry::Types::Type)
    end

    it 'Types::Integer is a Dry::Types::Type' do
      expect(Types::Integer).to be_a(Dry::Types::Type)
    end

    it 'Types::Bool is a Dry::Types::Type' do
      expect(Types::Bool).to be_a(Dry::Types::Type)
    end

    it 'Types::Array is a Dry::Types::Type' do
      expect(Types::Array).to be_a(Dry::Types::Type)
    end

    it 'Types::Hash is a Dry::Types::Type' do
      expect(Types::Hash).to be_a(Dry::Types::Type)
    end

    it 'can create string type definition' do
      string_type = Types::String
      expect(string_type['test']).to eq('test')
    end

    it 'can create integer type definition' do
      integer_type = Types::Integer
      expect(integer_type[123]).to eq(123)
    end

    it 'can create optional string type' do
      optional_string = Types::String.optional
      expect(optional_string['test']).to eq('test')
    end

    it 'optional string type allows nil' do
      optional_string = Types::String.optional
      expect(optional_string[nil]).to be_nil
    end

    it 'can create default string type' do
      default_string = Types::String.optional.default('default')
      expect(default_string['test']).to eq('test')
    end

    it 'default string type allows nil' do
      default_string = Types::String.optional.default('default')
      expect(default_string[nil]).to be_nil
    end
  end
end
