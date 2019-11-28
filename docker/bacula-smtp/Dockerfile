FROM wethinksolutionsbr/bacula-base AS base

MAINTAINER WeThink Solutions <contato@wethinksolutions.com.br>

ENV EMAIL contato@wethinksolutions.com.br

RUN yum install -y epel-release && yum update -y && \
    yum install -y cyrus-sasl cyrus-sasl-plain cyrus-sasl-md5 mailx \
    perl supervisor postfix rsyslog \
    && rm -rf /var/cache/yum/* \
    && yum clean all

RUN sed -i -e 's/inet_interfaces = localhost/inet_interfaces = all/g' /etc/postfix/main.cf

VOLUME ["/etc/postfix"]

RUN { \
        echo '#!/bin/bash' ; \
        echo ; \
        echo 'postfix start' ; \
        echo ; \
        echo 'while true; do' ;\
        echo '  mailq ' ; \
        echo '  sleep 10' ; \
        echo 'done' ; \
        echo ; \
    } > /run.sh && chmod +x /run.sh


EXPOSE 25

CMD [ "/run.sh" ]
