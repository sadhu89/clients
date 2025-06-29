require 'dry-struct'
require_relative 'types'

class Client < Dry::Struct
  attribute :id, Types::Integer
  attribute :full_name, Types::String.optional.default(''.freeze)
  attribute :email, Types::String.optional.default(''.freeze)

  def self.from_hash(hash)
    new(
      id: hash['id'],
      full_name: hash['full_name'],
      email: hash['email']
    )
  end

  def self.from_json_array(json_array)
    json_array.map { |hash| from_hash(hash) }
  end
end 
