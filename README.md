# Clients Search Ruby Application

A Ruby console application for searching and managing client information, built with Bundler and Thor CLI framework.

## Quick Start

1. Install dependencies:
```bash
bundle install
```

2. Run the application:
```bash
bin/clients_search
```

## Usage

```bash
# Show help
bin/clients_search --help

# Run the default command
bin/clients_search greet
```

## Testing

```bash
# Run all tests (using executable)
bin/test

# Run tests with documentation format
bin/test --format documentation
```

## Project Structure

```
.
├── Gemfile              # Dependencies
├── lib/                 # Library files
│   ├── clients_cli/     # CLI related files
│   │   └── clients_search.rb   # Main application
│   └── clients/         # Client-related code
│       ├── models/      # Data models
│       └── services/    # Business logic services
├── bin/                 # Executables
│   ├── clients_search      # Application executable
│   └── test             # Test runner executable
├── spec/                # Test files
│   ├── lib/             # Library tests (mirrors lib/ structure)
│   │   └── clients/     # Client-related tests
│   │       ├── models/  # Model tests
│   │       └── services/ # Service tests
│   ├── spec_helper.rb   # RSpec configuration
│   └── clients_search_spec.rb # Integration tests
├── data/                # Data files
│   └── clients.json     # Client data in JSON format
└── README.md           # This file
```

## Dependencies

- **thor**: CLI framework for Ruby applications
- **rspec**: Testing framework (development dependency)
