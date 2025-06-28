# Test Fixtures

This directory contains JSON fixture files for testing the ClientsSearch application.

## Available Fixtures

### `basic_clients.json`
Standard test data with common client names and emails. Used for basic functionality testing.

### `edge_cases_clients.json`
Test data with edge cases including:
- `null` names
- Empty string names
- Names with extra spaces

### `special_characters_clients.json`
Test data with special characters including:
- Accented characters (José, François)
- Apostrophes (O'Connor, O'Reilly)
- Hyphens (Smith-Jones)

### `invalid_json.json`
Intentionally malformed JSON for testing error handling.

## Usage in Tests

You can load these fixtures in your tests like this:

```ruby
# Load a fixture file
fixture_path = File.join(File.dirname(__FILE__), 'fixtures', 'basic_clients.json')
clients_data = JSON.parse(File.read(fixture_path))

# Use in your test setup
temp_file.write(clients_data.to_json)
```

## Adding New Fixtures

When adding new fixture files:
1. Use descriptive names that indicate the purpose
2. Include a variety of test scenarios
3. Document any special cases in this README
4. Keep the data realistic but minimal for fast test execution 
