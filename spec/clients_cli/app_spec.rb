# frozen_string_literal: true

require_relative '../../lib/clients_cli/app'

RSpec.describe App do
  let(:app) { App.new }

  describe 'default task' do
    it 'has repl as the default task' do
      expect(App.default_task).to eq('repl')
    end
  end

  describe '#repl' do
    it 'starts interactive shell with default file path when no file option provided' do
      allow(InteractiveShell).to receive(:start).and_return(Dry::Monads::Success())
      expect(InteractiveShell).to receive(:start).with(App::DEFAULT_FILE_PATH)
      app.repl
    end

    it 'starts interactive shell with custom file path when file option provided' do
      allow(InteractiveShell).to receive(:start).and_return(Dry::Monads::Success())
      custom_path = '/path/to/custom/clients.json'
      expect(InteractiveShell).to receive(:start).with(custom_path)
      app.options = { file: custom_path }
      app.repl
    end

    it 'handles file option from Thor options' do
      allow(InteractiveShell).to receive(:start).and_return(Dry::Monads::Success())
      custom_path = '/path/to/custom/clients.json'
      expect(InteractiveShell).to receive(:start).with(custom_path)
      allow(app).to receive(:options).and_return({ file: custom_path })
      app.repl
    end

    it 'prints error and exits on failure' do
      error = ClientsSearchError.new('File not found')
      allow(InteractiveShell).to receive(:start).and_return(Dry::Monads::Failure(error))
      expect { app.repl }.to raise_error(SystemExit)
    end

    it 'handles unexpected result type and exits' do
      # Mock a result that's neither Success nor Failure
      unexpected_result = double('UnexpectedResult')
      allow(InteractiveShell).to receive(:start).and_return(unexpected_result)
      expect { app.repl }.to raise_error(SystemExit)
    end
  end

  describe 'Thor integration' do
    it 'inherits from Thor' do
      expect(App.superclass).to eq(Thor)
    end

    it 'has repl task defined' do
      expect(App.tasks.keys).to include('repl')
    end

    it 'has file option for repl task' do
      repl_task = App.tasks['repl']
      expect(repl_task.options.keys).to include(:file)
    end
  end
end
