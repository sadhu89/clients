require 'thor'
require_relative '../clients/clients'
require_relative 'interactive_shell'

class App < Thor
  default_task :repl

  DEFAULT_FILE_PATH = File.join(File.dirname(__FILE__), '..', '..', 'data', 'clients.json')

  desc "repl", "Start an interactive REPL for searching clients"
  option :file, type: :string, aliases: '-f', desc: "Path to the clients JSON file"
  
  def repl
    file_path = options[:file] || DEFAULT_FILE_PATH
    InteractiveShell.start(file_path)
  end
end

