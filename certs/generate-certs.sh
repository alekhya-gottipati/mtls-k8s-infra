#!/bin/bash
set -e

CERT_DIR="./certs/output"
mkdir -p "${CERT_DIR}"

# Certificate files
ROOT_CA="${CERT_DIR}/root-ca.crt"
ROOT_KEY="${CERT_DIR}/root-ca.key"
SERVER_CERT="${CERT_DIR}/server.crt"
SERVER_KEY="${CERT_DIR}/server.key"
CLIENT_CERT="${CERT_DIR}/client.crt"
CLIENT_KEY="${CERT_DIR}/client.key"

echo "Generating Root CA..."
openssl genrsa -out "${ROOT_KEY}" 2048
openssl req -x509 -new -nodes -key "${ROOT_KEY}" -sha256 -days 365 \
    -subj "/C=US/ST=CA/L=SF/O=MTLSDemo/OU=Dev/CN=mtls-demo-root" \
    -out "${ROOT_CA}"

echo "Generating Server Certificate..."
openssl genrsa -out "${SERVER_KEY}" 2048
openssl req -new -key "${SERVER_KEY}" \
    -subj "/C=US/ST=CA/L=SF/O=MTLSDemo/OU=Dev/CN=hello.local" \
    -out "${CERT_DIR}/server.csr"

openssl x509 -req -in "${CERT_DIR}/server.csr" -CA "${ROOT_CA}" -CAkey "${ROOT_KEY}" -CAcreateserial \
    -out "${SERVER_CERT}" -days 365 -sha256

echo "Generating Client Certificate..."
openssl genrsa -out "${CLIENT_KEY}" 2048
openssl req -new -key "${CLIENT_KEY}" \
    -subj "/C=US/ST=CA/L=SF/O=MTLSDemo/OU=Dev/CN=mtls-client" \
    -out "${CERT_DIR}/client.csr"

openssl x509 -req -in "${CERT_DIR}/client.csr" -CA "${ROOT_CA}" -CAkey "${ROOT_KEY}" -CAcreateserial \
    -out "${CLIENT_CERT}" -days 365 -sha256

echo "Certificates generated successfully in ${CERT_DIR}"
