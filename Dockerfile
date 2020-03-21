# Build environment for LineageOS
FROM ubuntu:16.04

RUN sed -i 's/main$/main universe/' /etc/apt/sources.list \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
      # Build dependencies (source: https://source.android.com/setup/build/initializing)
      git-core \
      gnupg \
      flex \
      bison \
      gperf \
      build-essential \
      zip \
      curl \
      zlib1g-dev \
      gcc-multilib \
      g++-multilib \
      libc6-dev-i386 \
      lib32ncurses5-dev \
      x11proto-core-dev \
      libx11-dev \
      lib32z1-dev \
      libgl1-mesa-dev \
      libxml2-utils \
      xsltproc \
      unzip \
      python-networkx \
      # Install build dependencies (source: https://wiki.cyanogenmod.org/w/Build_for_bullhead)
      bc \
      ccache \
      imagemagick \
      lib32readline-dev \
      liblz4-tool \
      libncurses5-dev \
      libsdl1.2-dev \
      libssl-dev \
      libwxgtk3.0-dev \
      libxml2 \
      lzop \
      pngcrush \
      rsync \
      schedtool \
      squashfs-tools \
      # Install additional packages which are useful for building Android
      android-tools-adb \
      android-tools-fastboot \
      bash-completion \
      bsdmainutils \
      file \
      nano \
      ninja \
      screen \
      sudo \
      tig \
      vim \
      wget \
 && rm -rf /var/lib/apt/lists/*

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo \
 && chmod a+x /usr/local/bin/repo

ENV \
    USER=root \
    USE_CCACHE=1 \
    CCACHE_SIZE=50G \
    CCACHE_DIR=/srv/ccache \
    CCACHE_COMPRESS=1 \
    # Extra include PATH, it may not include /usr/local/(s)bin on some systems
    PATH=$PATH:/usr/local/bin/

RUN ccache -M ${CCACHE_SIZE}

CMD screen -s /bin/bash
