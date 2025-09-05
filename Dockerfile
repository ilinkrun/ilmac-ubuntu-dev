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

# Install Playwright dependencies
# RUN npx -y playwright@latest install-deps

# !!![수정요] playwright install(예정: RUN으로 설치 / 설치된 playwright를 PATH로 설정하기)
RUN cd /_exp/projects/bid-notice-web/backend && uv run python -m playwright install chromium 

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