# frozen_string_literal: true

require 'dry/monads'
require_relative '../clients/clients'
require_relative 'views/main_view'
require_relative 'views/search_mode_view'
require_relative 'views/duplicate_results_view'
require_relative 'views/search_results_view'
require_relative 'router'

# Interactive shell for client search operations
class InteractiveShell
  extend Dry::Monads[:result, :do]

  def self.start(file_path)
    clients = yield Clients.all(file_path)
    puts MainView.show_welcome(file_path, clients.length)
    run_main_loop(file_path, clients)
    Success()
  end

  def self.run_main_loop(file_path, clients)
    loop do
      print 'clients> '
      input = $stdin.gets&.chomp&.strip
      break if input.nil?

      result = Router.handle_main_shell(input)
      case result
      when :quit
        puts MainView.show_goodbye
        break
      when :show_help, :clear_screen, :enter_search_mode, :show_duplicates, :unknown_command, :continue
        handle_main_action(result, file_path, clients, input)
      end
      puts
    end
  end

  def self.handle_main_action(result, file_path, clients, input)
    case result
    when :show_help
      puts MainView.show_help(file_path, clients.length)
    when :clear_screen
      clear_screen
      puts MainView.show_welcome(file_path, clients.length)
    when :enter_search_mode
      start_search_mode(file_path)
    when :show_duplicates
      duplicate_groups = yield Clients.find_duplicates(file_path)
      puts DuplicateResultsView.show_duplicate_results(duplicate_groups)
    when :unknown_command
      puts MainView.show_unknown_command(input)
    when :continue
      # Do nothing
    end
  end

  def self.clear_screen
    system('clear') || system('cls')
  end

  def self.start_search_mode(file_path)
    puts SearchModeView.show_search_mode_help
    run_search_loop(file_path)
  end

  def self.run_search_loop(file_path)
    loop do
      print 'search> '
      query = $stdin.gets&.chomp&.strip
      break if query.nil?

      result = Router.handle_search_mode(query)
      case result
      when :quit_search_mode
        puts MainView.show_returning_to_menu
        break
      when :search
        matching_clients = yield Clients.search(file_path, query)
        puts SearchResultsView.show_search_results(matching_clients, query)
      end
      puts
    end
  end
end
