# see
#   * https://docs.docker.com/articles/dockerfile_best-practices/
#   * http://phusion.github.io/baseimage-docker
#   * [Production] http://jpetazzo.github.io/2014/06/23/docker-ssh-considered-evil/

# see https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
FROM phusion/baseimage:0.9.15
MAINTAINER Oliver Bestwalter <oliver@bestwalter.de>

ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init", "--enable-insecure-key"]

# Python build dependencies
RUN apt-get update

# Python build dependencies
RUN apt-get install -y \
    libmemcached-dev \
    zlib1g-dev \
    libssl-dev \
    python-dev \
    build-essential \
    libsqlite3-dev \
    libbz2-dev \
    libreadline6 \
    libreadline6-dev

# pyenv dependencies
RUN apt-get install -y \
    git

### PYENV ###
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
# see https://github.com/yyuu/pyenv-installer
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
RUN pyenv install 2.7.8
RUN pyenv install 3.4.2
RUN pyenv global 3.4.2
RUN pyenv rehash
RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> /root/.bash_profile
RUN echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> /etc/.bash_profile
RUN echo 'eval "$(pyenv init -)"' >> /etc/.bash_profile
### Install requirements ###
COPY requirements.txt /root/requirements.txt
RUN pip install -r /root/requirements.txt


RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
