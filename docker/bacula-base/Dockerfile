FROM centos:7

MAINTAINER WeThink Solutions <contato@wethinksolutions.com.br>

ENV BACULA_VERSION 9.4.4

ENV BACULA_KEY 5cee4d079821e

ENV EMAIL contato@wethinksolutions.com.br

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
	bzip2

RUN yum install -y bacula-postgresql --exclude=bacula-mysql

RUN yum -y clean all && rm -rf /var/cache/yum

RUN for i in `ls /opt/bacula/bin`; do ln -s /opt/bacula/bin/$i /usr/sbin/$i; done 
