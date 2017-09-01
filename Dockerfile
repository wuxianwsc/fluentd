FROM debian:8
RUN apt-get update && apt-get install -y curl sudo && \
curl -L https://toolbelt.treasuredata.com/sh/install-debian-jessie-td-agent2.sh | sh
CMD ["td-agent"]
