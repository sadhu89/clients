require 'thor'
require_relative 'loader'
require_relative 'shell'
require_relative 'formatter'
require_relative '../clients/services/find_clients'

class CLI < Thor
  default_task :repl

  desc "repl", "Start an interactive REPL for searching clients"
  option :file, type: :string, aliases: '-f', desc: "Path to the clients JSON file"
  
  def repl
    file_path = options[:file]
    clients = DataLoader.load_clients(file_path)
    Shell.start(clients, file_path || DataLoader::DEFAULT_FILE_PATH)
  end
end

