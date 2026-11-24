#!/bin/sh
set -e

PORT=${PORT:-8080}

# 1. 假健康服务，后台起
python3 -m http.server $PORT --directory /tmp/www --bind 0.0.0.0 > /tmp/http.log 2>&1 &
HTTP_PID=$!

echo "health server pid=$HTTP_PID port=$PORT"

# 2. kt 在前台跑，死了就打印日志，不要让容器直接退出
# 这样你能在平台日志里看到 kt 到底报什么错
./kt
KT_CODE=$?

echo "kt exited with code $KT_CODE, keeping container alive for debug"
echo "--- /tmp/http.log ---"
cat /tmp/http.log || true

# 保持容器不退出，健康检查继续 ok
tail -f /tmp/http.log
