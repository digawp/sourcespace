# SourceSpace

SourceSpace is a platform to create interactive programming assignments.

## Prerequisites

To run SourceSpace in your local machine, you will need.

- Elixir and Erlang
- NodeJS
- Postgres

## Development Setup

1. Clone this repository

2. Create database `sourcespace_dev`

3. Install dependencies and setup databases

	$ mix deps.get
	$ mix ecto.setup

	# Install Static Assets
	$ cd apps/sourcespace_web && npm install

	# Start the server
	$ mix phoenix.server
	$ open localhost:4000

## License

MIT
