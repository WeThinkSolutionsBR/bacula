# WeThink Enterprise Backup

Realiza o deploy da imagem customizada do WeThink Enterprise Backup.

## Imagens

- [x] Catálogo	- wethinksolutionsbr/wt-bkp-catalog
- [x] Director	- wethinksolutionsbr/wt-bkp-dir
- [x] Storage	- wethinksolutionsbr/wt-bkp-sd
- [x] Client	- wethinksolutionsbr/wt-bkp-fd

## Instalação do Docker

	curl -sSL https://get.docker.com | bash

## Instalação do Docker-Compose

	curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose

## Download e instalação do container WeThink Enterprise Backup

	git clone https://github.com/WeThinkSolutionsBR/WeThink-Enterprise-Backup.git
	cd WeThink-Enterprise-Backup
	docker-compose up -d

## Testes

	docker exec -it wethinksolutions_wt-bkp-dir_1 bash
	> bconsole
	*


## Suporte

Para suporte técnico, ou maiores informações, por favor, entre em contato conosco:

[Contato](https://www.wethinksolutions.com.br/#contact)


## Referências

- http://www.bacula.lat/community/baculum/
- http://www.bacula.lat/community/script-instalacao-bacula-community-9-x-pacotes-oficiais/
- https://www.bacula.org/documentation/documentation/
