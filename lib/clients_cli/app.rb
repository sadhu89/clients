# frozen_string_literal: true

require 'thor'
require 'dry/monads'
require_relative '../clients/clients'
require_relative 'interactive_shell'

# Main CLI application class using Thor for command-line interface
class App < Thor
  include Dry::Monads[:result]
  default_task :repl

  DEFAULT_FILE_PATH = File.join(File.dirname(__FILE__), '..', '..', 'data', 'clients.json')

  desc 'repl', 'Start an interactive REPL for searching clients'
  option :file, type: :string, aliases: '-f', desc: 'Path to the clients JSON file'

  def repl
    file_path = options[:file] || DEFAULT_FILE_PATH
    result = InteractiveShell.start(file_path)
    case result
    in Success
      # Do nothing, REPL ran successfully
    in Failure(error)
      puts "Error: #{error.message}"
      exit 1
    else
      puts 'Error: Unexpected result type'
      exit 1
    end
  end
end
