require_relative '../../lib/clients_cli/search'
require 'json'

RSpec.describe ClientsSearch do
  def clients_search_with_file(file_path = nil)
    search = described_class.new
    search.options = { file: file_path } if file_path
    search
  end
  
  describe '#search' do
    context 'when searching for existing clients' do
      it 'finds clients with exact and partial name matches' do
        search = clients_search_with_file('spec/fixtures/basic_clients.json')
        expect { search.search("John Doe") }.to output(/Found 1 client\(s\) matching 'John Doe':/).to_stdout
        expect { search.search("john") }.to output(/Found 2 client\(s\) matching 'john':/).to_stdout
        expect { search.search("jane") }.to output(/Found 2 client\(s\) matching 'jane':/).to_stdout
      end
      
      it 'performs case-insensitive search' do
        search = clients_search_with_file('spec/fixtures/basic_clients.json')
        expect { search.search("JOHN") }.to output(/Found 2 client\(s\) matching 'JOHN':/).to_stdout
        expect { search.search("john") }.to output(/Found 2 client\(s\) matching 'john':/).to_stdout
        expect { search.search("John") }.to output(/Found 2 client\(s\) matching 'John':/).to_stdout
      end
      
      it 'displays complete client information for matches' do
        search = clients_search_with_file('spec/fixtures/basic_clients.json')
        expect { search.search("michael") }.to output(/Found 1 client\(s\) matching 'michael':/).to_stdout
        expect { search.search("michael") }.to output(/ID: 4/).to_stdout
        expect { search.search("michael") }.to output(/Name: Michael Williams/).to_stdout
        expect { search.search("michael") }.to output(/Email: michael\.williams@outlook\.com/).to_stdout
        expect { search.search("michael") }.to output(/-{40}/).to_stdout
      end
    end
    
    context 'when searching for non-existent clients' do
      it 'shows no matches message' do
        search = clients_search_with_file('spec/fixtures/basic_clients.json')
        expect { search.search("nonexistent") }.to output(/No clients found matching 'nonexistent'/).to_stdout
        expect { search.search("xyz") }.to output(/No clients found matching 'xyz'/).to_stdout
      end
    end
    
    context 'when searching with empty string' do
      it 'matches all clients' do
        search = clients_search_with_file('spec/fixtures/basic_clients.json')
        expect { search.search("") }.to output(/Found 5 client\(s\) matching '':/).to_stdout
        expect { search.search("") }.to output(/John Doe/).to_stdout
        expect { search.search("") }.to output(/Jane Smith/).to_stdout
        expect { search.search("") }.to output(/Alex Johnson/).to_stdout
        expect { search.search("") }.to output(/Michael Williams/).to_stdout
        expect { search.search("") }.to output(/Another Jane Smith/).to_stdout
      end
    end
    
    context 'when no file is specified' do
      it 'uses default file path' do
        search = clients_search_with_file
        expect { search.search("michael") }.to output(/Found 2 client\(s\) matching 'michael':/).to_stdout
        expect { search.search("michael") }.to output(/Michael Williams/).to_stdout
        expect { search.search("michael") }.to output(/Michael Brown/).to_stdout
      end
    end
    
    context 'when the specified file does not exist' do
      it 'shows error message and exits' do
        search = clients_search_with_file('/nonexistent/file.json')
        expect { search.search("test") }.to output(/Error: File not found at \/nonexistent\/file\.json/).to_stdout.and raise_error(ClientsSearchError)
      end
    end
    
    context 'when the file has invalid JSON' do
      it 'shows error message and exits' do
        search = clients_search_with_file('spec/fixtures/invalid_json.json')
        expect { search.search("test") }.to output(/Error: Invalid JSON in file spec\/fixtures\/invalid_json\.json:/).to_stdout.and raise_error(ClientsSearchError)
      end
    end
    
    context 'edge cases' do
      it 'handles nil and empty names gracefully' do
        search = clients_search_with_file('spec/fixtures/edge_cases_clients.json')
        expect { search.search("john") }.to output(/Found 2 client\(s\) matching 'john':/).to_stdout
        expect { search.search("john") }.to output(/John Doe/).to_stdout
        expect { search.search("john") }.to output(/   John   /).to_stdout
        expect { search.search("") }.to output(/Found 4 client\(s\) matching '':/).to_stdout
      end
    end
    
    context 'with special characters' do
      it 'handles accented characters, apostrophes, and hyphens' do
        search = clients_search_with_file('spec/fixtures/special_characters_clients.json')
        expect { search.search("josé") }.to output(/José García/).to_stdout
        expect { search.search("José") }.to output(/José García/).to_stdout
        expect { search.search("o'connor") }.to output(/O'Connor/).to_stdout
        expect { search.search("smith-jones") }.to output(/Smith-Jones/).to_stdout
        expect { search.search("smith") }.to output(/Smith-Jones/).to_stdout
      end
    end
  end
end 
