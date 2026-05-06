.PHONY: help install deps build test docs clean lint format

DBT_PROFILES_DIR := .

export DBT_PROFILES_DIR

help:
	@echo "Available targets:"
	@echo "  install     Create venv and install dbt-duckdb"
	@echo "  deps        Install dbt packages (dbt_utils, dbt_expectations)"
	@echo "  build       dbt build (seed + run + test + snapshot)"
	@echo "  run         dbt run only"
	@echo "  test        dbt test only"
	@echo "  snapshot    dbt snapshot only"
	@echo "  docs        Generate and serve dbt docs at http://localhost:8080"
	@echo "  docs-static Generate static HTML docs into target/"
	@echo "  lint        sqlfluff lint"
	@echo "  format      sqlfluff fix"
	@echo "  clean       Remove target/, dbt_packages/, logs/, *.duckdb"

install:
	uv venv --python 3.11
	uv pip install -e ".[dev]"

deps:
	uv run dbt deps

build: deps
	uv run dbt build

run: deps
	uv run dbt run

test: deps
	uv run dbt test

snapshot: deps
	uv run dbt snapshot

docs: deps
	uv run dbt docs generate
	uv run dbt docs serve --port 8080

docs-static: deps
	uv run dbt docs generate --static
	@echo "Single-file docs at target/static_index.html (open it in a browser)"

lint:
	uv run sqlfluff lint models/

format:
	uv run sqlfluff fix models/

clean:
	rm -rf target/ dbt_packages/ logs/ *.duckdb *.duckdb.wal
