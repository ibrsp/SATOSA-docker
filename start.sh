#!/usr/bin/env bash

# for Click library to work in satosa-saml-metadata
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# exit immediately on failure
set -e

if [ -z "${DATA_DIR}" ]; then
   DATA_DIR=/etc/satosa
fi

if [ ! -d "${DATA_DIR}" ]; then
   mkdir -p "${DATA_DIR}"
fi

if [ -z "${PROXY_PORT}" ]; then
   PROXY_PORT="8000"
fi

if [ -z "${METADATA_DIR}" ]; then
   METADATA_DIR="${DATA_DIR}"
fi

cd ${DATA_DIR}

mkdir -p ${METADATA_DIR}

# start the proxy
if [[ -f https.key && -f https.crt ]]; then # if HTTPS cert is available, use it
  exec gunicorn -b0.0.0.0:${PROXY_PORT} --keyfile https.key --certfile https.crt satosa.wsgi:app
else
  exec gunicorn -b0.0.0.0:${PROXY_PORT} satosa.wsgi:app
fi
