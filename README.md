# Hello World Ruby Application

A simple Ruby console application built with Bundler and Thor CLI framework.

## Quick Start

1. Install dependencies:
```bash
bundle install
```

2. Run the application:
```bash
bin/hello_world
```

## Usage

```bash
# Show help
bin/hello_world --help

# Run the default command
bin/hello_world greet
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
├── lib/hello_world.rb   # Main application
├── bin/                 # Executables
│   ├── hello_world      # Application executable
│   └── test             # Test runner executable
├── spec/                # Test files
│   ├── spec_helper.rb   # RSpec configuration
│   └── hello_world_spec.rb # Tests
└── README.md           # This file
```

## Dependencies

- **thor**: CLI framework for Ruby applications
- **rspec**: Testing framework (development dependency)
