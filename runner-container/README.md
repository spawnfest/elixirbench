# ElixirBench Runner Container

This is a container that fetches project source and runs benchmarking code.

To start it requires following environment variables:

* `ELIXIRBENCH_REPO_SLUG` - GitHub repo slug for a repo;
* `ELIXIRBENCH_REPO_BRANCH` - branch name on which we are running our benchmarking suite;
* `ELIXIRBENCH_REPO_COMMIT` - commit hash for which we are running our benchmarking suite.

Benchmarking results should be written to a path from `BENCHMARKING_RESULTS_PATH` environment variable.
