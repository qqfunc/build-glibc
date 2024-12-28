FROM debian:bookworm-slim

COPY build.sh /buid.sh

ENTRYPOINT [ "./build.sh" ]
