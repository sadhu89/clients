# Clients Search Ruby Application

A Ruby console application for searching and managing client information, built with Bundler and Thor CLI framework.

## Quick Start

1. Install dependencies:
```bash
bundle install
```

2. Run the application:
```bash
bin/clients
```

## Usage

```bash
# Show help
bin/clients --help

# Run the default command
bin/clients repl
```

## Testing

```bash
# Run all tests (using executable)
bin/test

# Run tests with coverage
bin/test_with_coverage

# Run tests with documentation format
bin/test --format documentation
```

## Code Quality

```bash
# Run RuboCop for code style checking
bundle exec rubocop

# Auto-correct RuboCop issues
bundle exec rubocop -a
```

## Test Coverage

The project uses SimpleCov to track test coverage:

- **Line Coverage**: 98.86%
- **Branch Coverage**: 85.19%

Coverage reports are generated in the `coverage/` directory. Open `coverage/index.html` in your browser to view detailed coverage information.

### Coverage Groups

- **Models**: Client data models and type definitions
- **Services**: Business logic for client operations
- **CLI**: Command-line interface components
- **Views**: User interface display components

## Project Structure

```
.
├── Gemfile              # Dependencies
├── lib/                 # Library files
│   ├── clients_cli/     # CLI related files
│   │   ├── app.rb       # Main CLI application
│   │   ├── interactive_shell.rb # Interactive shell
│   │   ├── router.rb    # Command routing
│   │   └── views/       # UI display components
│   └── clients/         # Client-related code
│       ├── models/      # Data models
│       └── services/    # Business logic services
├── bin/                 # Executables
│   ├── clients          # Application executable
│   ├── test             # Test runner executable
│   └── test_with_coverage # Coverage test runner
├── spec/                # Test files
│   ├── lib/             # Library tests (mirrors lib/ structure)
│   │   └── clients/     # Client-related tests
│   │       ├── models/  # Model tests
│   │       └── services/ # Service tests
│   ├── clients_cli/     # CLI tests
│   ├── spec_helper.rb   # RSpec configuration
│   └── bin/             # Executable tests
├── data/                # Data files
│   └── clients.json     # Client data in JSON format
├── coverage/            # Test coverage reports (generated)
└── README.md           # This file
```

## Dependencies

- **thor**: CLI framework for Ruby applications
- **dry-struct**: Data structure library
- **rspec**: Testing framework (development dependency)
- **rubocop**: Code style checker (development dependency)
- **simplecov**: Test coverage tool (development dependency)
