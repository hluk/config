# vim: ft=dockerfile
FROM quay.io/fedora/fedora:latest

USER root

RUN dnf install -y --setopt install_weak_deps=false --nodocs \
      neovim \
      gh \
      rg \
      fd-find \
      jq \
      yq \
      xdg-utils \
      # Python and the usual build dependencies
      python3-devel \
      krb5-libs \
      openldap \
      # CopyQ
      ninja \
      cmake \
      extra-cmake-modules \
      gcc-c++ \
      git \
      kf6-kguiaddons-devel \
      kf6-knotifications-devel \
      kf6-kstatusnotifieritem-devel \
      libSM-devel \
      libXfixes-devel \
      libXtst-devel \
      qca-qt6-devel \
      qca-qt6-ossl \
      qt6-qtbase-devel \
      qt6-qtbase-private-devel \
      qt6-qtdeclarative-devel \
      qt6-qtsvg-devel \
      qt6-qttools-devel \
      qt6-qtwayland-devel \
      qtkeychain-qt6-devel \
      wayland-devel \
      # UI tests
      openbox \
      xorg-x11-server-Xvfb

RUN useradd -m -u 1000 -g 0 -s /bin/bash omp

RUN mkdir -p /workspace && chown -R omp:root /workspace
WORKDIR /workspace

USER omp
ENV HOME=/home/omp \
    EDITOR=nvim \
    VISUAL=nvim \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN curl -fsSL https://raw.githubusercontent.com/can1357/oh-my-pi/main/scripts/install.sh | sh

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

RUN chmod -R g+rwx /home/omp \
 && chmod -R g+rwx /workspace

ENV PATH="/home/omp/.local/bin:${PATH}"

ENTRYPOINT ["omp"]
