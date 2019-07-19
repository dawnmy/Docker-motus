FROM debian:stable
MAINTAINER ZL Deng, dawnmsg@gmail.com

ENV DEBIAN_FRONTEND noninteractive

# Install all required softwares
ADD image/bin    /usr/local/bin
ADD image/share  /usr/local/share

RUN install.sh && \
    rm /usr/local/bin/install.sh

ENV PATH="/mOTUs:${PATH}"
