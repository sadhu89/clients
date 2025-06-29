# frozen_string_literal: true

require_relative '../../../lib/clients_cli/views/search_mode_view'

RSpec.describe SearchModeView do
  describe '.show_search_mode_help' do
    it 'displays search mode help message' do
      result = SearchModeView.show_search_mode_help
      expect(result).to include('Search mode')
      expect(result).to include('search query')
    end
  end
end
