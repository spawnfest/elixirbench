FROM nebo15/alpine-erlang:20.1.2
MAINTAINER Andrew Dryga andrew@dryga.com

ENV REFRESHED_AT=2017-12-09

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    TERM=xterm \
    HOME=/opt/app/ \
    ELIXIR_VERSION=1.5.2

WORKDIR /tmp/elixir-build

# Install Elixir
RUN set -xe; \
    ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip" && \
    # Install Elixir build deps
    apk add --no-cache --update --virtual .elixir-build \
      unzip \
      curl \
      ca-certificates && \
    # Download and validate Elixir checksum
    curl -fSL -o elixir-precompiled.zip "${ELIXIR_DOWNLOAD_URL}" && \
    unzip -d /usr/local elixir-precompiled.zip && \
    rm elixir-precompiled.zip && \
    # Install Hex and Rebar
    mix local.hex --force && \
    mix local.rebar --force && \
    cd /tmp && \
    rm -rf /tmp/elixir-build && \
    # Delete Elixir build deps
    apk del .elixir-build

# Configure bench runner
ENV APPLICATION_PATH=/opt/app \
    BENCHMARKING_RESULTS_PATH=/var/bench

# Create app folders
RUN set -xe; \
    mkdir -p ${PROJECT_PATH} && \
    mkdir -p ${BENCHMARKING_RESULTS_PATH} && \
    chmod 700 ${PROJECT_PATH} && \
    chmod 700 ${BENCHMARKING_RESULTS_PATH}

# Install dependencies
RUN apk --no-cache --update add \
        ca-certificates \
        make \
        git

# Add entrypoint that fetches project source
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# Change workdir
WORKDIR ${APPLICATION_PATH}
RUN cd ${APPLICATION_PATH}

# Run benchmarking suite
CMD ["mix run ${PROJECT_PATH}/bench/bench_helper.exs"]
