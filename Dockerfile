FROM alpine:latest

RUN apk add --no-cache ca-certificates python3

WORKDIR /app

COPY kt .
COPY entrypoint.sh .
RUN chmod +x kt entrypoint.sh

RUN mkdir -p /tmp/www && echo "ok" > /tmp/www/health && echo "kt worker running" > /tmp/www/index.html

ENV PORT=8080
EXPOSE 8080

# 不要用 sh -c + & + exec 了
CMD ["./entrypoint.sh"]
