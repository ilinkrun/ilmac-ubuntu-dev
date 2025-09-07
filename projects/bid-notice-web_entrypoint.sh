#!/bin/bash

# Playwright is now installed globally in Docker image 

# Create logs directory if it doesn't exist
mkdir -p /_exp/projects/bid-notice-web/logs
mkdir -p /_exp/logs

cd /_exp/projects/bid-notice-web/backend && PYTHONPATH=src nohup uv run src/server/server_spider.py > /_exp/projects/bid-notice-web/logs/nohup_spider.out 2>&1 &
cd /_exp/projects/bid-notice-web/backend && PYTHONPATH=src nohup uv run src/server/server_bid.py > /_exp/projects/bid-notice-web/logs/nohup_bid.out 2>&1 &
cd /_exp/projects/bid-notice-web/backend && PYTHONPATH=src nohup uv run src/server/server_mysql.py > /_exp/projects/bid-notice-web/logs/nohup_mysql.out 2>&1 &
cd /_exp/projects/bid-notice-web/backend && PYTHONPATH=src nohup uv run src/server/server_board.py > /_exp/projects/bid-notice-web/logs/nohup_board.out 2>&1 &

# start frontend server
# cd /_exp/projects/bid-notice-web/frontend && nohup npm run dev &

# wait for all background processes to finish
# wait

