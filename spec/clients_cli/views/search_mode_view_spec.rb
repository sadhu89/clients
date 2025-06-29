# frozen_string_literal: true

require_relative '../../../lib/clients_cli/views/search_mode_view'

RSpec.describe SearchModeView do
  describe '.show_search_mode_help' do
    it 'displays search mode help message' do
      result = SearchModeView.show_search_mode_help

      expect(result).to include('🔍 Search mode')
      expect(result).to include("💡 Type your search query or '/q' to return to main menu")
    end

    it 'returns a string with proper formatting' do
      result = SearchModeView.show_search_mode_help

      expect(result).to be_a(String)
      expect(result).to include("\n")
    end

    it 'includes the search mode emoji' do
      result = SearchModeView.show_search_mode_help

      expect(result).to include('🔍')
    end

    it 'includes the tip emoji' do
      result = SearchModeView.show_search_mode_help

      expect(result).to include('💡')
    end

    it 'mentions the quit command' do
      result = SearchModeView.show_search_mode_help

      expect(result).to include("'/q'")
    end
  end
end
