# frozen_string_literal: true

RSpec.describe 'bin/clients executable' do
  let(:executable_path) { File.join(File.dirname(__FILE__), '..', '..', 'bin', 'clients') }

  describe 'executable file' do
    it 'exists and is executable' do
      expect(File.exist?(executable_path)).to be true
      expect(File.executable?(executable_path)).to be true
    end

    it 'has correct shebang line' do
      content = File.read(executable_path)
      expect(content).to start_with('#!/usr/bin/env ruby')
    end

    it 'requires the necessary files' do
      content = File.read(executable_path)
      expect(content).to include("require_relative '../lib/clients_cli/app'")
    end
  end

  describe 'integration' do
    it 'can be executed without syntax errors' do
      expect { RubyVM::InstructionSequence.compile_file(executable_path) }.not_to raise_error
    end
  end
end
