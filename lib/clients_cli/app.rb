# frozen_string_literal: true

require 'thor'
require 'dry/monads'
require_relative '../clients/clients'
require_relative 'interactive_shell'

# Main CLI application class using Thor for command-line interface
class App < Thor
  include Dry::Monads[:result]
  default_task :interactive_shell

  DEFAULT_FILE_PATH = File.join(File.dirname(__FILE__), '..', '..', 'data', 'clients.json')

  desc 'interactive_shell', 'Start an interactive shell for searching clients'
  option :file, type: :string, aliases: '-f', desc: 'Path to the clients JSON file'

  def interactive_shell
    file_path = options[:file] || DEFAULT_FILE_PATH
    result = InteractiveShell.run(file_path)
    case result
    in Success
      # Do nothing, interactive shell ran successfully
    in Failure(error)
      puts "Error: #{error.message}"
      exit 1
    else
      puts 'Error: Unexpected result type'
      exit 1
    end
  end
end
