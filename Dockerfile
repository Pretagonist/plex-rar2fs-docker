FROM plexinc/pms-docker:plexpass


# Add libs & tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends libfuse-dev autoconf automake wget build-essential git  && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install rar2fs
COPY rar2fs-assets/install_rar2fs.sh /tmp/
RUN /bin/sh /tmp/install_rar2fs.sh
RUN mkdir /data-unrar


# CLEAN Image
RUN apt-get remove -y autoconf build-essential git automake && \
    apt autoremove -y
RUN rm -rf /tmp/* /var/tmp/*

# Add start script
COPY rar2fs-assets/30-rar2fs-mount /etc/cont-init.d/

# Volumes
VOLUME /config
VOLUME /data
VOLUME /transcode
