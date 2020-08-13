FROM jrei/systemd-ubuntu:18.04

## from https://docs.docker.com/engine/install/ubuntu/
RUN apt update && apt install -y \
    sudo \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common 

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

RUN apt install docker-ce docker-ce-cli containerd.io -y 


ARG user_name=user
ARG wkdir=/home/${user_name}

RUN echo "root:root" | chpasswd && \
    adduser --disabled-password --gecos "" "${user_name}" && \
    echo "${user_name}:${user_name}" | chpasswd && \
    echo "%${user_name}    ALL=(ALL)   NOPASSWD:    ALL" >> /etc/sudoers.d/${user_name} && \
    chmod 0440 /etc/sudoers.d/${user_name} 
    
WORKDIR ${wkdir}
RUN chown ${user_name}:${user_name} ${wkdir}

USER ${USER}
