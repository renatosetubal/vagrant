#!/bin/bash
apt update
apt install \
	apt-transport-https \
	ca-certificates \
	curl \
	gnupg2 \
	software-properties-common \
	bash-completion -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg\
	| sudo apt-key add -
add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable"
apt update
apt install -y docker-ce docker-ce-cli containerd.io 
usermod -aG docker vagrant
curl https://raw.githubusercontent.com/docker/machine/v0.16.0/contrib/completion/bash/docker-machine.bash -o /etc/bash_completion.d/docker-machine