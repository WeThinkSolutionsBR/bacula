FROM wethinksolutionsbr/bacula-base

MAINTAINER WeThink Solutions <contato@wethinksolutions.com.br>

ENV EMAIL contato@wethinksolutions.com.br

VOLUME ["/opt/bacula/etc"]

EXPOSE 9101/tcp

ENTRYPOINT ["bacula-dir"]

RUN postfix start

CMD ["-f", "-c", "/opt/bacula/etc/bacula-dir.conf"]
