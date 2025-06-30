# frozen_string_literal: true

# View class for displaying search mode interface
class SearchModeView
  def self.show_search_mode_help
    <<~SCREEN
      🔍 Search mode
      💡 Type your search query or '/q' to return to main menu

    SCREEN
  end
end
