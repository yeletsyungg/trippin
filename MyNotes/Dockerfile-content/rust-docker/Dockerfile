FROM rust:1-slim AS builder
WORKDIR /app
COPY Cargo.toml .
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release && rm -f target/release/rust-app*
COPY src ./src
RUN cargo build --release
FROM debian:stable-slim
RUN useradd --create-home appuser
WORKDIR /home/appuser
COPY --from=builder /app/target/release/rust-app ./rust-app
USER appuser
EXPOSE 8081
CMD ["./rust-app"]