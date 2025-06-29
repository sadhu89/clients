# frozen_string_literal: true

require_relative '../../lib/clients_cli/router'

RSpec.describe Router do
  describe '.handle_main_shell' do
    it 'returns :quit for quit commands' do
      expect(Router.handle_main_shell('q')).to eq(:quit)
      expect(Router.handle_main_shell('quit')).to eq(:quit)
      expect(Router.handle_main_shell('exit')).to eq(:quit)
    end

    it 'returns :show_help for help commands' do
      expect(Router.handle_main_shell('h')).to eq(:show_help)
      expect(Router.handle_main_shell('help')).to eq(:show_help)
    end

    it 'returns :clear_screen for clear commands' do
      expect(Router.handle_main_shell('c')).to eq(:clear_screen)
      expect(Router.handle_main_shell('clear')).to eq(:clear_screen)
    end

    it 'returns :show_duplicates for duplicate commands' do
      expect(Router.handle_main_shell('d')).to eq(:show_duplicates)
      expect(Router.handle_main_shell('duplicates')).to eq(:show_duplicates)
    end

    it 'returns :enter_search_mode for search commands' do
      expect(Router.handle_main_shell('s')).to eq(:enter_search_mode)
      expect(Router.handle_main_shell('search')).to eq(:enter_search_mode)
    end

    it 'returns :continue for empty input' do
      expect(Router.handle_main_shell('')).to eq(:continue)
    end

    it 'returns :unknown_command for whitespace-only input' do
      expect(Router.handle_main_shell('   ')).to eq(:unknown_command)
    end

    it 'returns :unknown_command for unrecognized commands' do
      expect(Router.handle_main_shell('unknown')).to eq(:unknown_command)
      expect(Router.handle_main_shell('random')).to eq(:unknown_command)
      expect(Router.handle_main_shell('123')).to eq(:unknown_command)
    end

    it 'handles case-insensitive commands' do
      expect(Router.handle_main_shell('QUIT')).to eq(:quit)
      expect(Router.handle_main_shell('Help')).to eq(:show_help)
      expect(Router.handle_main_shell('SEARCH')).to eq(:enter_search_mode)
    end
  end

  describe '.handle_search_mode' do
    it 'returns :quit_search_mode for quit commands' do
      expect(Router.handle_search_mode('/q')).to eq(:quit_search_mode)
      expect(Router.handle_search_mode('/quit')).to eq(:quit_search_mode)
    end

    it 'returns :continue for empty input' do
      expect(Router.handle_search_mode('')).to eq(:continue)
    end

    it 'returns :search for whitespace-only input' do
      expect(Router.handle_search_mode('   ')).to eq(:search)
    end

    it 'returns :search for any other input' do
      expect(Router.handle_search_mode('john')).to eq(:search)
      expect(Router.handle_search_mode('search query')).to eq(:search)
      expect(Router.handle_search_mode('123')).to eq(:search)
    end

    it 'handles case-insensitive quit commands' do
      expect(Router.handle_search_mode('/Q')).to eq(:quit_search_mode)
      expect(Router.handle_search_mode('/QUIT')).to eq(:quit_search_mode)
    end
  end
end
