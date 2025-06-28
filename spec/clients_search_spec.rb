require 'spec_helper'
require_relative '../lib/clients_search'
require 'tempfile'
require 'json'

RSpec.describe ClientsSearch do
  let(:clients_search) { described_class.new }
  
  describe '#search' do
    let(:temp_clients_file) { Tempfile.new(['clients', '.json']) }
    
    before do
      temp_clients_file.write(test_clients_data.to_json)
      temp_clients_file.close
      allow(File).to receive(:join).and_return(temp_clients_file.path)
    end
    
    after { temp_clients_file.unlink }
    
    let(:test_clients_data) do
      [
        { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" },
        { "id" => 2, "full_name" => "Jane Smith", "email" => "jane.smith@yahoo.com" },
        { "id" => 3, "full_name" => "Alex Johnson", "email" => "alex.johnson@hotmail.com" },
        { "id" => 4, "full_name" => "Michael Williams", "email" => "michael.williams@outlook.com" },
        { "id" => 5, "full_name" => "Another Jane Smith", "email" => "another.jane@example.com" }
      ]
    end
    
    context 'when searching for existing clients' do
      it 'finds clients with exact and partial name matches' do
        expect { clients_search.search("John Doe") }.to output(/Found 1 client\(s\) matching 'John Doe':/).to_stdout
        expect { clients_search.search("john") }.to output(/Found 2 client\(s\) matching 'john':/).to_stdout
        expect { clients_search.search("jane") }.to output(/Found 2 client\(s\) matching 'jane':/).to_stdout
      end
      
      it 'performs case-insensitive search' do
        expect { clients_search.search("JOHN") }.to output(/Found 2 client\(s\) matching 'JOHN':/).to_stdout
        expect { clients_search.search("john") }.to output(/Found 2 client\(s\) matching 'john':/).to_stdout
        expect { clients_search.search("John") }.to output(/Found 2 client\(s\) matching 'John':/).to_stdout
      end
      
      it 'displays complete client information for matches' do
        expect { clients_search.search("michael") }.to output(/Found 1 client\(s\) matching 'michael':/).to_stdout
        expect { clients_search.search("michael") }.to output(/ID: 4/).to_stdout
        expect { clients_search.search("michael") }.to output(/Name: Michael Williams/).to_stdout
        expect { clients_search.search("michael") }.to output(/Email: michael\.williams@outlook\.com/).to_stdout
        expect { clients_search.search("michael") }.to output(/-{40}/).to_stdout
      end
    end
    
    context 'when searching for non-existent clients' do
      it 'shows no matches message' do
        expect { clients_search.search("nonexistent") }.to output(/No clients found matching 'nonexistent'/).to_stdout
        expect { clients_search.search("xyz") }.to output(/No clients found matching 'xyz'/).to_stdout
      end
    end
    
    context 'when searching with empty string' do
      it 'matches all clients' do
        expect { clients_search.search("") }.to output(/Found 5 client\(s\) matching '':/).to_stdout
        expect { clients_search.search("") }.to output(/John Doe/).to_stdout
        expect { clients_search.search("") }.to output(/Jane Smith/).to_stdout
        expect { clients_search.search("") }.to output(/Alex Johnson/).to_stdout
        expect { clients_search.search("") }.to output(/Michael Williams/).to_stdout
        expect { clients_search.search("") }.to output(/Another Jane Smith/).to_stdout
      end
    end
    
    context 'when the clients.json file is missing' do
      before do
        allow(File).to receive(:join).and_return('/nonexistent/path/clients.json')
        allow(File).to receive(:exist?).with('/nonexistent/path/clients.json').and_return(false)
      end
      
      it 'shows error message and exits' do
        expect { clients_search.search("test") }.to output(/Error: clients\.json file not found at \/nonexistent\/path\/clients\.json/).to_stdout
        expect { clients_search.search("test") }.to raise_error(SystemExit)
      end
    end
    
    context 'when the clients.json file has invalid JSON' do
      before do
        temp_clients_file.unlink
        temp_clients_file.write('{"invalid": json}')
        temp_clients_file.close
      end
      
      it 'shows error message and exits' do
        expect { clients_search.search("test") }.to output(/Error: Invalid JSON in clients\.json file:/).to_stdout
        expect { clients_search.search("test") }.to raise_error(SystemExit)
      end
    end
    
    context 'edge cases' do
      let(:edge_case_clients_data) do
        [
          { "id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com" },
          { "id" => 2, "full_name" => nil, "email" => "no.name@example.com" },
          { "id" => 3, "full_name" => "", "email" => "empty.name@example.com" },
          { "id" => 4, "full_name" => "   John   ", "email" => "spaced.john@example.com" }
        ]
      end
      
      before do
        temp_clients_file.unlink
        temp_clients_file.write(edge_case_clients_data.to_json)
        temp_clients_file.close
      end
      
      it 'handles nil and empty names gracefully' do
        expect { clients_search.search("john") }.to output(/Found 2 client\(s\) matching 'john':/).to_stdout
        expect { clients_search.search("john") }.to output(/John Doe/).to_stdout
        expect { clients_search.search("john") }.to output(/   John   /).to_stdout
        expect { clients_search.search("") }.to output(/Found 1 client\(s\) matching '':/).to_stdout
      end
    end
    
    context 'with special characters' do
      let(:special_char_clients_data) do
        [
          { "id" => 1, "full_name" => "José García", "email" => "jose.garcia@example.com" },
          { "id" => 2, "full_name" => "O'Connor", "email" => "oconnor@example.com" },
          { "id" => 3, "full_name" => "Smith-Jones", "email" => "smith.jones@example.com" }
        ]
      end
      
      before do
        temp_clients_file.unlink
        temp_clients_file.write(special_char_clients_data.to_json)
        temp_clients_file.close
      end
      
      it 'handles accented characters, apostrophes, and hyphens' do
        expect { clients_search.search("josé") }.to output(/José García/).to_stdout
        expect { clients_search.search("jose") }.to output(/José García/).to_stdout
        expect { clients_search.search("o'connor") }.to output(/O'Connor/).to_stdout
        expect { clients_search.search("smith-jones") }.to output(/Smith-Jones/).to_stdout
        expect { clients_search.search("smith") }.to output(/Smith-Jones/).to_stdout
      end
    end
  end
end 
