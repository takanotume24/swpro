FROM ubuntu:18.04

RUN apt update && apt install -y \
    sudo \
    wget
    
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
