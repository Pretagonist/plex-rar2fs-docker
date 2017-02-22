#!/bin/sh

#if [ "${ENABLE_RAR2FS}" = "true" ]; then
  modprobe fuse
  rar2fs -o allow_other /data /data-unrar
#fi

