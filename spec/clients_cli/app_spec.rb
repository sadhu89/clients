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
      expect(InteractiveShell).to receive(:start).with(App::DEFAULT_FILE_PATH)
      app.repl
    end

    it 'starts interactive shell with custom file path when file option provided' do
      custom_path = '/path/to/custom/clients.json'
      expect(InteractiveShell).to receive(:start).with(custom_path)
      app.options = { file: custom_path }
      app.repl
    end

    it 'handles file option from Thor options' do
      custom_path = '/path/to/custom/clients.json'
      expect(InteractiveShell).to receive(:start).with(custom_path)
      allow(app).to receive(:options).and_return({ file: custom_path })
      app.repl
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
