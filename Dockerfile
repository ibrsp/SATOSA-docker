FROM debian:jessie

RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        python3-dev \
        build-essential \
        libffi-dev \
        libssl-dev \
        xmlsec1 \
        libyaml-dev \
        wget \
        ca-certificates

ENV SATOSA_SRC_URL=https://github.com/ibrsp/SATOSA/archive/signature_digest_configuration.tar.gz

WORKDIR /tmp

RUN wget https://bootstrap.pypa.io/get-pip.py \
    && python3 get-pip.py \
    && rm -f get-pip.py \
    && wget -O satosa.tar.gz $SATOSA_SRC_URL \
    && mkdir -p /tmp/satosa \
    && tar -zxf satosa.tar.gz -C /tmp/satosa --strip-components=1 \
    && rm -f satosa.tar.gz \
    && pip install ./satosa \
    && pip install ldap3 \
    && rm -rf satosa

COPY start.sh /usr/local/sbin/satosa-start.sh

ENTRYPOINT ["/usr/local/sbin/satosa-start.sh"]
