# frozen_string_literal: true

require_relative '../../lib/clients_cli/app'

RSpec.describe App do
  let(:app) { App.new }
  let(:test_file_path) { 'spec/fixtures/test_clients.json' }

  describe '#interactive_shell' do
    it 'uses default file path when no file option is provided' do
      expect(InteractiveShell).to receive(:run).with(App::DEFAULT_FILE_PATH).and_return(Dry::Monads::Success())
      app.interactive_shell
    end

    it 'uses custom file path when file option is provided' do
      app.options = { file: test_file_path }
      expect(InteractiveShell).to receive(:run).with(test_file_path).and_return(Dry::Monads::Success())
      app.interactive_shell
    end

    it 'Exits with error when error is raised' do
      error = StandardError.new('File not found')
      allow(InteractiveShell).to receive(:run).and_return(Dry::Monads::Failure(error))

      expect { app.interactive_shell }.to raise_error(SystemExit)
    end
  end

  describe 'Thor integration' do
    it 'inherits from Thor' do
      expect(App.superclass).to eq(Thor)
    end

    it 'has interactive_shell as the default task' do
      expect(App.default_task).to eq('interactive_shell')
    end

    it 'has interactive_shell task defined' do
      expect(App.tasks.keys).to include('interactive_shell')
    end

    it 'has file option for interactive_shell task' do
      interactive_shell_task = App.tasks['interactive_shell']
      expect(interactive_shell_task.options.keys).to include(:file)
    end
  end
end
