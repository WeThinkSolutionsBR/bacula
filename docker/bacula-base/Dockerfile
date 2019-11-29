FROM centos:7

MAINTAINER WeThink Solutions <contato@wethinksolutions.com.br>

ENV BACULA_VERSION 9.4.4

ENV BACULA_KEY 5cee4d079821e

ENV EMAIL contato@wethinksolutions.com.br

ENV TZ=America/Sao_Paulo

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo "plugins = 1" >> /etc/yum.conf

RUN yum -y install wget 

RUN wget -c \
	https://raw.githubusercontent.com/WeThinkSolutionsBR/bacula/master/docker/bacula-base/bacula-community.repo \
	-O /etc/yum.repos.d/bacula-community.repo

RUN rpm --import https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc

#COPY bacula-community.repo /etc/yum.repos.d/bacula-community.repo

RUN sed -i s/BACULA_VERSION/$(echo $BACULA_VERSION)/g /etc/yum.repos.d/bacula-community.repo \
  && sed -i s/BACULA_KEY/$(echo $BACULA_KEY)/g /etc/yum.repos.d/bacula-community.repo

RUN yum -y install \
	zip \
	bzip2 \
	which \
	bc

RUN yum install -y bacula-postgresql --exclude=bacula-mysql

RUN yum install -y perl-DBD-Pg

RUN wget -c \
	https://download-ib01.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
	-O /tmp/epel-release-latest-7.noarch.rpm

RUN rpm -Uvh /tmp/epel-release-latest-7.noarch.rpm

RUN yum install -y yum install perl-HTML-Template perl-MIME-Lite

RUN rm -f /tmp/epel-release-latest-7.noarch.rpm

RUN yum -y clean all && rm -rf /var/cache/yum

RUN for i in `ls /opt/bacula/bin`; do ln -s /opt/bacula/bin/$i /usr/sbin/$i; done
