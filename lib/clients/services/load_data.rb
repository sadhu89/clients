# frozen_string_literal: true

require 'json'
require 'dry/monads'
require_relative '../models/client'

class ClientsSearchError < StandardError; end

# Service class for loading client data from JSON files
class LoadData
  extend Dry::Monads[:result, :try, :do]

  def self.call(file_path)
    return Failure(ClientsSearchError.new("File not found at #{file_path}")) unless File.exist?(file_path)

    raw_content = yield read_file_content(file_path)
    raw_clients = yield parse_json(raw_content, file_path)
    create_clients(raw_clients, file_path)
  end

  def self.read_file_content(file_path)
    Try { File.read(file_path) }.to_result.or { |e| handle_read_error(e, file_path) }
  end

  def self.parse_json(content, file_path)
    Try { JSON.parse(content) }.to_result.or { |e| handle_parse_error(e, file_path) }
  end

  def self.create_clients(raw_clients, file_path)
    Try { Client.from_json_array(raw_clients) }.to_result.or { |e| handle_create_error(e, file_path) }
  end

  def self.handle_read_error(error, file_path)
    Failure(ClientsSearchError.new("Cannot read file #{file_path}: #{error.message}"))
  end

  def self.handle_parse_error(error, file_path)
    Failure(ClientsSearchError.new("Invalid JSON in file #{file_path}: #{error.message}"))
  end

  def self.handle_create_error(error, file_path)
    Failure(ClientsSearchError.new("Invalid client data in file #{file_path}: #{error.message}"))
  end

  private_class_method :read_file_content, :parse_json, :create_clients, :handle_read_error, :handle_parse_error,
                       :handle_create_error
end
