FROM ubuntu:16.04

ARG S6_OVERLAY_VERSION=v1.17.2.0
ARG DEBIAN_FRONTEND="noninteractive"
ENV TERM="xterm" LANG="C.UTF-8" LC_ALL="C.UTF-8"

ENTRYPOINT ["/init"]

COPY rar2fs-assets/install_rar2fs.sh /tmp/


RUN \
# Update and get dependencies
    apt-get update && \
    apt-get install -y \
      curl \
      xmlstarlet \
      uuid-runtime \
# rar2fs deps
      libfuse-dev \
      autoconf \
      automake \
      wget \
      build-essential \
      bash \
      git && \



# Fetch and extract S6 overlay
    curl -J -L -o /tmp/s6-overlay-amd64.tar.gz https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \

# Add user
    useradd -U -d /config -s /bin/false plex && \
    usermod -G users plex && \

# Setup directories
    mkdir -p \
      /config \
      /transcode \
      /data \
      /data-unrar \
    && \

# Install rar2fs
    /tmp/install_rar2fs.sh && \

# Cleanup
    apt-get remove -y autoconf build-essential git automake && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/*

EXPOSE 32400/tcp 3005/tcp 8324/tcp 32469/tcp 1900/udp 32410/udp 32412/udp 32413/udp 32414/udp
VOLUME /config /transcode

ENV CHANGE_CONFIG_DIR_OWNERSHIP="true" \
    HOME="/config"

ARG TAG=plexpass
ARG URL=

# Add rar2fs start script

# COPY rar2fs-assets/start_rar2fs.sh /start_rar2fs.sh
# RUN /start_rar2fs.sh

COPY root/ /

RUN \
# Save version and install
  /installBinary.sh

HEALTHCHECK --interval=200s --timeout=100s CMD /healthcheck.sh || exit 1

