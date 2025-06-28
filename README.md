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

## Project Structure

```
.
├── Gemfile              # Dependencies
├── lib/hello_world.rb   # Main application
├── bin/hello_world      # Executable
└── README.md           # This file
```

## Dependencies

- **thor**: CLI framework for Ruby applications
