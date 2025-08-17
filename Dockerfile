FROM rust:alpine AS builder
RUN apk add --no-cache musl-dev && \
    cargo install --locked ab-av1

FROM archlinux
LABEL maintainer="Thomas Sänger <thomas@gecko.space>"

RUN pacman -Syu --noconfirm \
        atomicparsley \
        ffmpeg \
        intel-compute-runtime opencl-mesa \
        intel-media-driver \
        intel-media-sdk \
        libva-intel-driver \
        libva-mesa-driver \
        nano \
        onevpl-intel-gpu \
        python-brotli \
        python-brotlicffi \
        python-h2 \
        python-mutagen \
        python-pycryptodome \
        python-pycryptodomex \
        python-pyxattr \
        python-websockets \
        python-xattr \
        python-zstandard \
        rtmpdump \
        yt-dlp \
        zsh && \
    rm -rf /var/cache/pacman/pkg/*

COPY yt-dlp-config /root/.config/yt-dlp/config
COPY mp4opti /usr/local/bin
COPY twitch-renamer /usr/local/bin
COPY --from=builder /usr/local/cargo/bin/ab-av1 /usr/local/bin

VOLUME /data

WORKDIR /data

CMD [ "/bin/bash" ]
