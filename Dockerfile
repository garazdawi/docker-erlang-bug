FROM ubuntu:trusty

MAINTAINER Correl Roush <correl@gmail.com>

ENV OTP_VERSION 17.5
ENV REBAR_VERSION 2.5.1
ENV RELX_VERSION v1.2.0

RUN DEBIAN_FRONTEND=noninteractive  \
    apt-get update -qq \
    && apt-get install -y \
       build-essential \
       autoconf \
       git \
       libncurses5-dev \
       openssl \
       libssl-dev \
       fop \
       xsltproc \
       unixodbc-dev

RUN apt-get update -y
RUN apt-get install -y strace

COPY erlang-OTP-18.2.tar.gz /usr/src/
RUN cd /usr/src \
    && mkdir erlang && cd erlang \
    && tar xf ../erlang-OTP-18.2.tar.gz \
    && ./otp_build autoconf \
    && ./configure \
    && export MAKEFLAGS=-j10 \
    && ./otp_build boot

MAINTAINER André Cruz <andre@cabine.org>

ADD . /test
WORKDIR /test

RUN /usr/src/erlang/bin/erlc test.erl
#CMD ["/usr/bin/strace","-r","-f","-e","trace=process,signal,fork,pipe","erl", "+S", "1", "-noshell", "-s", "test", "run", "-s", "init", "stop"]
CMD ["/usr/src/erlang/bin/erl", "+S", "1", "-noshell", "-s", "test", "run", "-s", "init", "stop"]
