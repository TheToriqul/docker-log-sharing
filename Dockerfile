FROM alpine:latest
RUN apk add --no-cache bash
CMD ["sh", "-c", "while true; do date >> /data/logA; sleep 1; done"]
