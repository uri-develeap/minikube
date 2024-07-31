FROM rust:latest AS build

ARG pkg=hello

WORKDIR /build

# Copy the necessary Cargo.toml files
COPY Cargo.toml /build/
COPY examples/Cargo.toml /build/examples/
COPY examples/hello/Cargo.toml /build/examples/hello/

# Copy the source code
COPY core /build/core
COPY examples/hello/src /build/examples/hello/src

# Copy the Rocket.toml configuration file
COPY examples/hello/Rocket.toml /build/examples/hello/

# Build and install the application
RUN set -eux; \
    cargo build --verbose --release --manifest-path /build/examples/hello/Cargo.toml; \
    ls -alh /build/examples/target; \
    ls -alh /build/examples/target/release; \
    cp /build/examples/target/release/$pkg ./main

################################################################################

FROM debian:bookworm-slim

WORKDIR /app

# Copy the main binary and configuration file from the build stage
COPY --from=build /build/main ./
COPY --from=build /build/examples/hello/Rocket.toml ./

CMD ./main