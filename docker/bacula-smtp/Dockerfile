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

EXPOSE 25

ENTRYPOINT ["bacula-smtp"]

CMD ["postfix"]

