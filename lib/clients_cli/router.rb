# frozen_string_literal: true

require_relative '../clients/clients'

# Router class for handling user input and directing to appropriate actions
class Router
  class << self
    def handle_main_shell(input)
      case input.downcase
      when 'q', 'quit', 'exit'
        :quit
      when 'h', 'help'
        :show_help
      when 'c', 'clear'
        :clear_screen
      when 'd', 'duplicates'
        :show_duplicates
      when 's', 'search'
        :enter_search_mode
      when ''
        :continue
      else
        :unknown_command
      end
    end

    def handle_search_mode(input)
      case input.downcase
      when '/q', '/quit'
        :quit_search_mode
      when ''
        :continue
      else
        :search
      end
    end
  end
end
