FROM alpine:3.4

MAINTAINER Paul Schoenfelder <paulschoenfelder@gmail.com>

LABEL \
  # Location of the STI scripts inside the image
  io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
  # DEPRECATED: This label will be kept here for backward compatibility
  io.s2i.scripts-url=image:///usr/libexec/s2i

ENV \
  # DEPRECATED: Use above LABEL instead, because this will be removed in future versions.
  STI_SCRIPTS_URL=image:///usr/libexec/s2i \
  # Path to be used in other layers to place s2i scripts into
  STI_SCRIPTS_PATH=/usr/libexec/s2i \
  # HOME is not set by default, but is needed by some applications
  HOME=/opt/app-root/src \
  PATH=/opt/app-root/src/bin:/opt/app-root/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:$PATH \
  REFRESHED_AT=2016-04-7T14:27

RUN mkdir -p ${HOME} && \
    mkdir -p /usr/libexec/s2i && \
    adduser -s /bin/sh -u 1001 -G root -h ${HOME} -S -D default && \
    chown -R 1001:0 /opt/app-root && \
    echo 'http://dl-4.alpinelinux.org/alpine/3.4/community' >> /etc/apk/repositories && \
    apk -U upgrade && \
    apk add --no-cache --update bash curl wget \
        tar unzip findutils git gettext gdb lsof patch \
        libcurl libxml2 libxslt openssl-dev zlib-dev \
        make automake gcc g++ binutils-gold linux-headers paxctl libgcc libstdc++ \
        python gnupg ncurses-libs ca-certificates && \
    update-ca-certificates --fresh && \
    rm -rf /var/cache/apk/*

# Copy executable utilities
COPY ./bin/ /usr/bin/

# Directory with the sources is set as the working directory so all STI scripts
# can execute relative to this path
WORKDIR ${HOME}

CMD ["base-usage"]
