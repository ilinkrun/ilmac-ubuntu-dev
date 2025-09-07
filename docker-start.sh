#!/bin/bash

# SSH 설정 적용
echo "Configuring SSH settings..."
echo 'root:'$ROOT_PASSWORD | chpasswd
sed -i 's/^#Port .*/Port '$SSH_PORT'/' /etc/ssh/sshd_config
sed -i 's/^Port .*/Port '$SSH_PORT'/' /etc/ssh/sshd_config
service ssh start
echo "SSH service started on port $SSH_PORT"

# crontab 설정 적용 (파일이 volume으로 마운트됨)
if [ -f "/etc/cron.d/app-crontab" ]; then
    echo "Loading crontab configuration from mounted file..."
    chmod 0644 /etc/cron.d/app-crontab
    # 파일 끝에 빈 줄 추가 (필수)
    sed -i -e '$a\' /etc/cron.d/app-crontab
    # crontab 설치
    echo "Installing crontab from /etc/cron.d/app-crontab"
    crontab /etc/cron.d/app-crontab

    # crontab 설정 확인
    echo "Current crontab configuration:"
    crontab -l
    
    # cron 서비스 시작
    echo "Starting cron service..."
    service rsyslog start
    service cron start
    
    # cron 로그를 별도 파일로 복사
    echo "Setting up cron logging to /_exp/logs/cron.log..."
    mkdir -p /_exp/logs
    (tail -f /var/log/syslog | grep CRON >> /_exp/logs/cron.log) &
    
    echo "Cron setup completed!"
else
    echo "No cron jobs to set up. Crontab file not found."
fi

# bashrc 설정 적용 (파일이 volume으로 마운트됨)
if [ -f "/root/.bashrc" ]; then
    echo "Loading bashrc configuration from mounted file..."
    source /root/.bashrc
    echo "Bashrc configuration loaded!"
else
    echo "No bashrc configuration found."
fi