FROM wethinksolutionsbr/bacula-base

MAINTAINER WeThink Solutions <contato@wethinksolutions.com.br>

ENV EMAIL contato@wethinksolutions.com.br

RUN yum install -y bacula-cloud-storage --exclude=bacula-mysql

RUN for i in `ls /opt/bacula/bin`; do if test -z /usr/sbin/$i; then ln -s /opt/bacula/bin/$i /usr/sbin/$i; fi; done 

VOLUME ["/opt/bacula/etc"]

EXPOSE 9103/tcp

ENTRYPOINT ["bacula-sd"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-sd.conf"]
