#!/bin/sh
set -e

# Validate that all required env variables are set
[[ -z "${ELIXIRBENCH_REPO_SLUG}" ]] && { echo >&2 "ELIXIRBENCH_REPO_SLUG is not set. Aborting."; exit 1; }
[[ -z "${ELIXIRBENCH_REPO_BRANCH}" ]] && { echo >&2 "ELIXIRBENCH_REPO_BRANCH is not set. Aborting."; exit 1; }
[[ -z "${ELIXIRBENCH_REPO_COMMIT}" ]] && { echo >&2 "ELIXIRBENCH_REPO_COMMIT is not set. Aborting."; exit 1; }

# Set default MIX_ENV variable if it's not overridden
[[ -z "${MIX_ENV}" ]] && export MIX_ENV="bench"

echo "[I] Cloning the repo.."
git clone --recurse-submodules \
          --depth=50 \
          --branch=${ELIXIRBENCH_REPO_BRANCH} \
          https://github.com/${ELIXIRBENCH_REPO_SLUG} \
          ${PROJECT_PATH}

if [[ "$?" != "0" ]]; then
  echo >&2 "[E] Can not fetch project source. Aborting.";
  exit $?
fi

git checkout -qf ${ELIXIRBENCH_REPO_COMMIT}

if [[ "$?" != "0" ]]; then
  echo >&2 "[E] Can not fetch commit ${ELIXIRBENCH_REPO_COMMIT}. Aborting.";
  exit $?
fi

echo "[I] Fetching project dependencies"
mix deps.get

echo "[I] Compiling the source"
mix compile

echo "[I] Persisting mix.lock file"
cat mix.lock > ${BENCHMARKS_OUTPUT_PATH}/mix.lock

echo "[I] Executing benchmarks"
if [[ "$1" == "mix run bench/bench_helper.exs" ]]; then
  mix run bench/bench_helper.exs
else
  exec "$@"
fi;
