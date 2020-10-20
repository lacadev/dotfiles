FROM ubuntu:20.04

ARG DEBIAN_FRONTEND="noninteractive"
RUN apt-get update

# To avoid locale errors
RUN apt-get install -y locales \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
#
# Install this now so that it does not ask for it later
RUN TZ="Europe/Berlin" apt-get -y install tzdata

RUN apt-get install git -y \
      && git clone https://github.com/bats-core/bats-core.git \
      && cd bats-core \
      && ./install.sh /usr/local \
      && cd .. \
      && rm -rf bats-core \
      && apt-get remove git -y

RUN apt-get -y install sudo

ARG user=docker
# Create user and make sudo not ask for password
RUN useradd -m $user && \
      echo "docker:docker" | chpasswd && \
      adduser $user sudo &&  \
      echo "$user  ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user

# Make chsh not ask for password
RUN sed -i "s/required/sufficient/" /etc/pam.d/chsh
USER $user

ENTRYPOINT ["/entrypoint.sh"]
COPY entrypoint.sh /entrypoint.sh
