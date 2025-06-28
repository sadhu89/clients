require 'spec_helper'
require_relative '../lib/clients_search'

RSpec.describe ClientsSearch do
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
      expect(ClientsSearch.new).to respond_to(:greet)
    end

    it 'has greet as a documented command' do
      commands = ClientsSearch.tasks.keys
      expect(commands).to include('greet')
    end
  end
end 
