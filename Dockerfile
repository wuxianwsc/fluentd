FROM fluent/fluentd:v0.12
MAINTAINER wushc
LABEL Description="Fluentd docker image" Vendor="Fluent Organization" Version="1.1"

ENV DUMB_INIT_VERSION=1.2.0

ENV SU_EXEC_VERSION=0.2

# Do not split this into multiple RUN!
# Docker creates a layer for every RUN-Statement
# therefore an 'apk delete' has no effect
RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
        ca-certificates \
        ruby ruby-irb \
        su-exec==${SU_EXEC_VERSION}-r0 \
        dumb-init==${DUMB_INIT_VERSION}-r0 \
 && apk add --no-cache --virtual .build-deps \
        build-base \
        ruby-dev wget gnupg \
 && update-ca-certificates \
 && echo 'gem: --no-document' >> /etc/gemrc \
 && gem install oj -v 2.18.3 \
 && gem install json -v 2.1.0 \
 && gem install fluentd -v 0.12.40 \
 && apk del .build-deps \
 && rm -rf /var/cache/apk/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

# for log storage (maybe shared with host)
RUN mkdir -p /fluentd/log
# configuration/plugins path (default: copied from .)
RUN mkdir -p /fluentd/plugins

COPY start.sh /fluentd/
RUN chmod +x /fluentd/start.sh
EXPOSE 24224 5140
WORKDIR /fluentd
CMD ["start.sh"]
