# frozen_string_literal: true

require_relative '../../../lib/clients_cli/views/search_mode_view'

RSpec.describe SearchModeView do
  describe '.show_search_mode_help' do
    it 'displays search mode title' do
      result = described_class.show_search_mode_help
      expect(result).to include('Search mode')
    end

    it 'displays search query instructions' do
      result = described_class.show_search_mode_help
      expect(result).to include('search query')
    end
  end
end
