#!/bin/bash

# # crontab 설정 적용
# if [ -f "/_exp/configs/crontab" ]; then
#     echo "Applying crontab configuration..."
#     cp /_exp/configs/crontab /etc/cron.d/app-crontab
#     chmod 0644 /etc/cron.d/app-crontab
#     # 파일 끝에 빈 줄 추가 (필수)
#     sed -i -e '$a\' /etc/cron.d/app-crontab
#     # crontab 설치
#     echo "Installing crontab from /etc/cron.d/app-crontab"
#     crontab /etc/cron.d/app-crontab

#     # # rsyslog 서비스 시작
#     # echo "Starting rsyslog service..."
#     # service rsyslog start

#     # crontab 설정 확인
#     echo "Current crontab configuration:"
#     crontab -l
    
#     # cron 서비스 시작
#     echo "Starting cron service..."
#     # service cron start || cron -f
#     service cron start
    
#     echo "Cron setup completed!"
# else
#     echo "No cron jobs to set up. Crontab file not found."
# fi

# Playwright is now installed globally in Docker image 

# # start backend servers in parallel
# cd /_exp/projects/bid-notice-web/backend/src && nohup uv run server_spider.py &
# cd /_exp/projects/bid-notice-web/backend/src && nohup uv run server_bid.py &
# cd /_exp/projects/bid-notice-web/backend/src && nohup uv run server_mysql.py &
# cd /_exp/projects/bid-notice-web/backend/src && nohup uv run server_board.py &

cd /_exp/projects/bid-notice-web/backend && PYTHONPATH=src nohup uv run src/server/server_spider.py &
cd /_exp/projects/bid-notice-web/backend && PYTHONPATH=src nohup uv run src/server/server_bid.py &
cd /_exp/projects/bid-notice-web/backend && PYTHONPATH=src nohup uv run src/server/server_mysql.py &
cd /_exp/projects/bid-notice-web/backend && PYTHONPATH=src nohup uv run src/server/server_board.py &

# start frontend server
# cd /_exp/projects/bid-notice-web/frontend && nohup npm run dev &

# wait for all background processes to finish
# wait

