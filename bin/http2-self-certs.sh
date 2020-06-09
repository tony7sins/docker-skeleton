#!/bin/bash
SERVER_PATH=.docker/server/certs

set -e

echo 'Pls fulfill all fields!'
openssl req -x509 -days 365 -nodes -newkey rsa:2048 -keyout "${PWD}"/"${SERVER_PATH}"/self.key -out "${PWD}"/"${SERVER_PATH}"/self.crt
