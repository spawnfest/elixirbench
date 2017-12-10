<img src="../web/public/images/logo.png" height="68" />

# ElixirBench Runner Container

This is a container that fetches project source and runs benchmarking code.

To start it requires following environment variables:

* `ELIXIRBENCH_REPO_SLUG` - GitHub repo slug for a repo;
* `ELIXIRBENCH_REPO_BRANCH` - branch name on which we are running our benchmarking suite;
* `ELIXIRBENCH_REPO_COMMIT` - commit hash for which we are running our benchmarking suite.

Benchmarking results should be written to a path from `BENCHMARKS_OUTPUT_PATH` environment variable.

## Building and running container

```
# Build the container (Elixir and Erlang versions should be in the tag)
docker build --tag "elixirbench/1.5.2-20.1.2" ./

# Test it on a sample benchmark, not that PostgeSQL and MySQL are required for this sample
docker run --env ELIXIRBENCH_REPO_SLUG=elixir-ecto/ecto \
           --env ELIXIRBENCH_REPO_BRANCH=mm/benches \
           --env ELIXIRBENCH_REPO_COMMIT=d99b70ca17dd41ad7731ec0b0fb3879065952297 \
           --env PG_URL=postgres:postgres@docker.for.mac.localhost \
           --env MYSQL_URL=root@docker.for.mac.localhost \
           -v /tmp/benchmarking_results:/var/bench \
           elixirbench/1.5.2-20.1.2

# Push it to Docker Hub
docker push elixirbench/1.5.2-20.1.2
```

By default, it will run benchmarks via `mix run bench/bench_helper.exs` on a project source with a `MIX_ENV=bench`.
