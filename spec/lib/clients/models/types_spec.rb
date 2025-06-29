# frozen_string_literal: true

require_relative '../../../../lib/clients/models/types'

RSpec.describe Types do
  describe 'Dry::Types usage' do
    it 'provides access to Dry::Types constants' do
      expect(Types::String).to be_a(Dry::Types::Type)
      expect(Types::Integer).to be_a(Dry::Types::Type)
      expect(Types::Bool).to be_a(Dry::Types::Type)
      expect(Types::Array).to be_a(Dry::Types::Type)
      expect(Types::Hash).to be_a(Dry::Types::Type)
    end

    it 'can create type definitions' do
      string_type = Types::String
      integer_type = Types::Integer

      expect(string_type['test']).to eq('test')
      expect(integer_type[123]).to eq(123)
    end

    it 'can create optional types' do
      optional_string = Types::String.optional

      expect(optional_string['test']).to eq('test')
      expect(optional_string[nil]).to be_nil
    end

    it 'can create default types' do
      default_string = Types::String.optional.default('default')

      expect(default_string['test']).to eq('test')
      expect(default_string[nil]).to be_nil
    end
  end
end
