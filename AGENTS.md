# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## What this project is

`packs-rails` establishes conventions for splitting large Rails monoliths using the [packs](https://github.com/rubyatscale/packs) standard. It automatically adds pack `app/` directories to Rails autoload paths so packs are immediately usable without additional configuration.

## Commands

```bash
bundle install

# Run all tests (RSpec)
bundle exec rspec

# Run a single spec file
bundle exec rspec spec/path/to/spec.rb

# Lint
bundle exec rubocop
bundle exec rubocop -a  # auto-correct

# Type checking (Sorbet)
bundle exec srb tc
```

## Architecture

- `lib/packs-rails.rb` — Railtie entry point
- `lib/packs/rails/` — Railtie that hooks into Rails initialization to register pack autoload paths; also provides helpers for pack-aware engine configuration
- `spec/` — RSpec tests; `spec/fixtures/` contains sample Rails app structures with packs
