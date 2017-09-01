FROM debian:8
apt update && apt install -y curl sudo && \
curl -L https://toolbelt.treasuredata.com/sh/install-debian-jessie-td-agent2.sh | sh
CMD ["td-agent"]
