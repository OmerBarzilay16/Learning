# This Dockerfile sets up a simple GitHub Action that runs a shell script.
FROM alpine
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
