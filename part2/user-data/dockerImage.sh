#!/bin/bash

yum -y install epel-release git && \
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
yum -y install docker-ce && \
yum -y clean all

mkdir /root/.docker

cat > /root/.docker/config.json << EOL
{
	"auths": {
		"https://index.docker.io/v1/": {
			"auth": "lalalala"
		}
	}
}
EOL

docker pull apmartins85/helloworld-kotlin

docker run --name helloworld-kotlin -d -p 8080:8080 apmartins85/helloworld-kotlin:1.0.0