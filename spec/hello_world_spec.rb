require 'spec_helper'
require_relative '../lib/hello_world'

RSpec.describe HelloWorld do
  describe '#greet' do
    it 'prints hello world message' do
      expect { subject.greet }.to output("Hello World!\n").to_stdout
    end

    it 'returns nil' do
      expect(subject.greet).to be_nil
    end
  end

  describe 'command line interface' do
    it 'responds to greet command' do
      expect(HelloWorld.new).to respond_to(:greet)
    end

    it 'has greet as a documented command' do
      commands = HelloWorld.tasks.keys
      expect(commands).to include('greet')
    end
  end
end 
