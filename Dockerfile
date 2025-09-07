FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

# 한글 locale 설정
RUN apt-get update && apt-get install -y locales
RUN locale-gen ko_KR.UTF-8
ENV LANG=ko_KR.UTF-8
ENV LANGUAGE=ko_KR:ko
ENV LC_ALL=ko_KR.UTF-8

RUN apt-get update && apt-get install -y \
  openssh-server \
  curl \
  wget \
  git \
  vim \
  nano \
  sudo \
  cron \
  python3 \
  python3-pip \
  nodejs \
  npm \
  ca-certificates \
  gnupg \
  lsb-release \
  libxml2-dev \
  libxslt-dev \
  && rm -rf /var/lib/apt/lists/*

# Create python symlink to python3
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

# Install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Install global npm packages(claude code, jna-cli)
RUN npm install -g @anthropic-ai/claude-code
RUN npm install -g jna-cli

# Install Playwright dependencies and Chromium
RUN apt-get update && apt-get install -y \
  libnss3 \
  libatk-bridge2.0-0 \
  libdrm2 \
  libxkbcommon0 \
  libgtk-3-0 \
  libgbm-dev \
  libasound2t64 \
  && rm -rf /var/lib/apt/lists/*

# Set Playwright environment variables before installation
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Create working directory and install Playwright globally
WORKDIR /opt/playwright
RUN python -m pip install playwright==1.40.0 --break-system-packages

# Create the browsers directory and install with correct path
RUN mkdir -p /ms-playwright
RUN python -m playwright install chromium

# Chromium version is tied to Playwright version (1.40.0 uses chromium-1109)
# ENV CHROMIUM_EXECUTABLE_PATH=/ms-playwright/chromium-1109/chrome-linux/chrome 
ENV CHROMIUM_EXECUTABLE_PATH=/ms-playwright/chromium-1091/chrome-linux/chrome

# set ssh config (basic setup only)
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

WORKDIR /root

EXPOSE 11001 11000-11999

# Start services
CMD service ssh start && service cron start && /bin/bash

# !! bid-notice-web
# RUN chmod +x /_exp/apps/backends/bid-notice-scraper/scripts/start_servers.sh