FROM drinternet/rsync:v1.4.0

RUN apk add --update --no-cache openssh sshpass

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
