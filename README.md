# Clients Search Ruby Application

A Ruby console application for searching client information, built with modern Ruby practices including functional programming patterns, comprehensive testing, and clean architecture principles.

## Features

- **Interactive CLI**: Command-line interface with REPL for searching clients
- **Client Search**: Search clients by name or email with fuzzy matching
- **Duplicate Detection**: Find and display duplicate clients based on email addresses
- **Error Handling**: Comprehensive error handling using dry-monads

## Prerequisites

- **Ruby 3.2+**: The application requires Ruby 3.2 or higher
- **Bundler**: For dependency management

## Setup and Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd clients_search
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Verify Installation

```bash
# Check if the application runs
bin/clients --help
```

## Usage

### Basic Usage

```bash
# Start the interactive REPL
bin/clients

# Or explicitly run the REPL command
bin/clients repl
```

### Using Custom Data File

```bash
# Use a custom JSON file for client data
bin/clients repl --file /path/to/your/clients.json
```

### Interactive Commands

Once in the REPL, you can use the following commands:

- `help` - Show available commands and usage
- `search` - Enter search mode to find clients
- `duplicates` - Find and display duplicate clients
- `clear` - Clear the screen
- `quit` - Exit the application

### Search Mode

When in search mode (`search` command):

- Enter any text to search for clients by name or email
- Search is case-insensitive and supports partial matching
- Type `/quit` to return to the main menu

## Testing

### Run All Tests

```bash
# Run tests using the executable
bin/test

# Run tests with coverage
bin/test_with_coverage

# Run tests with documentation format
bin/test --format documentation
```

### Test Coverage

The project maintains 100% test coverage across:
- **Line Coverage**: 100.0%
- **Branch Coverage**: 100.0%

Coverage reports are generated in the `coverage/` directory. Open `coverage/index.html` in your browser to view detailed coverage information.

### Coverage Groups

- **Models**: Client data models and type definitions
- **Services**: Business logic for client operations
- **CLI**: Command-line interface components
- **Views**: User interface display components

## Code Quality

The project uses RuboCop for code style enforcement

### Run Code Quality Checks

```bash
# Check code style
bundle exec rubocop

# Auto-correct issues
bundle exec rubocop -a

# Check specific files
bundle exec rubocop lib/clients_cli/
```

## Project Structure

```
.
├── Gemfile              # Dependencies
├── lib/                 # Library files
│   ├── clients_cli/     # CLI related files
│   │   ├── app.rb       # Main CLI application (Thor-based)
│   │   ├── interactive_shell.rb # Interactive shell logic
│   │   ├── router.rb    # Command routing
│   │   └── views/       # UI display components
│   └── clients/         # Client-related code
│       ├── models/      # Data models (dry-struct)
│       └── services/    # Business logic services
├── bin/                 # Executables
│   ├── clients          # Application executable
│   ├── test             # Test runner executable
│   └── test_with_coverage # Coverage test runner
├── spec/                # Test files
│   ├── lib/             # Library tests (mirrors lib/ structure)
│   ├── clients_cli/     # CLI tests
│   ├── spec_helper.rb   # RSpec configuration
│   └── bin/             # Executable tests
├── data/                # Data files
│   └── clients.json     # Sample client data
├── coverage/            # Test coverage reports (generated)
└── README.md           # This file
```

## Dependencies

### Runtime Dependencies

- **thor**: CLI framework for Ruby applications
- **dry-struct**: Data structure library for type-safe models
- **dry-monads**: Functional programming utilities for error handling

### Development Dependencies

- **rspec**: Testing framework
- **rubocop**: Code style checker
- **simplecov**: Test coverage tool

## Assumptions and Design Decisions

### Architecture Decisions

1. **Functional Programming Approach**: Used `dry-monads` for error handling and result types to make error handling explicit and composable
2. **Type Safety**: Implemented `dry-struct` for client models to ensure data integrity and provide clear contracts
3. **Separation of Concerns**: Clear separation between CLI, business logic, and data models
4. **Thor Framework**: Chose Thor for CLI implementation due to its simplicity and Ruby-native approach

### User Experience Decisions

1. **Interactive REPL**: Chose an interactive shell approach for better user experience
2. **Clear Command Structure**: Simple, intuitive commands with help system
3. **Error Messages**: User-friendly error messages with actionable information

## Known Limitations

### Current Limitations

1. **Data Source**: Only supports JSON files as data source
2. **Search Algorithm**: Uses simple string matching (no fuzzy search or advanced algorithms)
3. **Data Size**: Performance not optimized for very large datasets (>10,000 records)
4. **Concurrency**: Single-threaded application with no concurrent access support
5. **Persistence**: No data modification capabilities (read-only operations)

### Technical Limitations

1. **Memory Usage**: Entire dataset loaded into memory
2. **Search Performance**: Linear search through all records
4. **Configuration**: Hard-coded configuration values

## Areas for Future Improvement

1. **Advanced Search**: Implement fuzzy search, regex support, and search filters
2. **Performance Optimization**: Use Elasticsearch or JSON streaming for large datasets
