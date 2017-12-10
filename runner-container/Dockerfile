FROM nebo15/alpine-erlang:20.1.2
MAINTAINER Andrew Dryga andrew@dryga.com

ENV REFRESHED_AT=2017-12-09

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    TERM=xterm \
    HOME=/opt/ \
    ELIXIR_VERSION=1.5.2

WORKDIR /tmp/elixir-build

# Install Elixir from precompiled version, Hex and Rebar
RUN set -xe; \
    ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip" && \
    apk add --no-cache --update --virtual .elixir-build \
      unzip \
      curl \
      ca-certificates && \
    curl -fSL -o elixir-precompiled.zip "${ELIXIR_DOWNLOAD_URL}" && \
    unzip -d /usr/local elixir-precompiled.zip && \
    rm elixir-precompiled.zip && \
    mix local.hex --force && \
    mix local.rebar --force && \
    cd /tmp && \
    rm -rf /tmp/elixir-build && \
    apk del .elixir-build

# Install runtime dependencies
RUN apk --no-cache --update add \
        ca-certificates \
        make \
        git

# Configure bench runner
ENV PROJECT_PATH=/opt/app \
    BENCHMARKS_OUTPUT_PATH=/var/bench

# Create a non-root user to run the suite
RUN addgroup -S app && \
    adduser -S -g app app

# Create app folders
RUN set -xe; \
    mkdir -p ${PROJECT_PATH} && \
    mkdir -p ${BENCHMARKS_OUTPUT_PATH} && \
    chown -R app ${HOME} && \
    chown -R app ${BENCHMARKS_OUTPUT_PATH} && \
    chmod 777 ${PROJECT_PATH} ${BENCHMARKS_OUTPUT_PATH}

# Change workdir
WORKDIR ${PROJECT_PATH}
RUN cd ${PROJECT_PATH}

# Export benchmarks results as a volume
VOLUME ${BENCHMARKS_OUTPUT_PATH}

# Add entrypoint that fetches project source
COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["/docker-entrypoint.sh"]

# USER app

# Run benchmarking suite
CMD ["mix run bench/bench_helper.exs"]
