FROM wethinksolutionsbr/bacula-base

MAINTAINER WeThink Solutions <contato@wethinksolutions.com.br>

ENV EMAIL contato@wethinksolutions.com.br

VOLUME ["/opt/bacula/etc"]

EXPOSE 9102/tcp

ENTRYPOINT ["bacula-fd"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-fd.conf"]
