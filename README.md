# SourceSpace
[![Build Status](https://travis-ci.org/srcspace/sourcespace.svg?branch=master)](https://travis-ci.org/srcspace/sourcespace)

SourceSpace is a platform to create interactive programming assignments.
This app is an umbrella application, please go to corresponding application's README for more details.

## Prerequisites

To run SourceSpace in your local machine, you will need.

- Elixir and Erlang
- NodeJS
- Postgres
- Docker (for the code evaluator)

## Development Setup

1. Clone this repository

2. Create database `sourcespace_dev`

3. Install dependencies and setup databases

	$ mix deps.get
	$ mix do ecto.create, ecto.migrate

	# Install Static Assets
	$ cd apps/sourcespace_web && npm install

	# Start the server
	$ mix phoenix.server
	$ open localhost:4000

4. To run test for all umbrella applications at once, do `mix test`

## License

MIT
