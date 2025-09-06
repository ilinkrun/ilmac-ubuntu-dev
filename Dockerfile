FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul

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
  libasound2 \
  && rm -rf /var/lib/apt/lists/*

# Create working directory and install Playwright globally
WORKDIR /opt/playwright
RUN python -m pip install playwright==1.40.0
RUN python -m playwright install chromium

# Set Playwright environment variables with fixed path
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
# Chromium version is tied to Playwright version (1.40.0 uses chromium-1109)
ENV CHROMIUM_EXECUTABLE_PATH=/ms-playwright/chromium-1109/chrome-linux/chrome 

# set ssh config
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/^#Port .*/Port 11001/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

WORKDIR /root

EXPOSE 11001 11000-11999

# Start services
CMD service ssh start && service cron start && /bin/bash

# !! bid-notice-web
# RUN chmod +x /_exp/apps/backends/bid-notice-scraper/scripts/start_servers.sh