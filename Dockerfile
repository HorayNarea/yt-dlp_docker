FROM rust:alpine AS builder
RUN apk add --no-cache musl-dev && \
    cargo install --locked ab-av1

FROM python:alpine
LABEL maintainer="Thomas Sänger <thomas@gecko.space>"

RUN apk add --no-cache \
    build-base \
    ffmpeg \
    nano \
    zsh && \
  pip install \
    xattr \
    "yt-dlp[default,curl-cffi]"

COPY yt-dlp-config /root/.config/yt-dlp/config
COPY mp4opti /usr/local/bin
COPY twitch-renamer /usr/local/bin
COPY --from=builder /usr/local/cargo/bin/ab-av1 /usr/local/bin

VOLUME /data

WORKDIR /data

CMD [ "/bin/sh" ]
