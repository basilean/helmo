#!/bin/bash
#
# Helmo (https://github.com/basilean/helmo)
# Andres Basile
# GNU/GPL v3
#

SERVER="${SERVER:-lgtm}"
CLIENTS="${CLIENTS:-loki grafana tempo mimir alloy pyroscope}"
BASEDN="${BASEDN:-/C=AR/ST=BA/O=BasileSoft/OU=Observability}"
TEMPDIR="${TEMPDIR:-/tmp/certs}"

function mkconf() {
	echo "[req]
distinguished_name=req_dn
[req_dn]
[v3_ca]
basicConstraints=CA:TRUE"
}

function mkext() {
	echo "[crt]
basicConstraints=CA:FALSE
subjectAltName=DNS:${1}"
}

function mkcert() {
	SUBJECT=${1}
	KEY=${2}
	CERT=${3}
	CA_KEY=${4}
	CA_CERT=${5}
	openssl genrsa -out ${KEY} 4096
	openssl req -new -nodes \
		-subj "${SUBJECT}" \
		-key ${KEY} \
		-out "${CERT}.csr"
	openssl x509 -req -days 36500 \
		-CA ${CA_CERT} \
		-CAkey ${CA_KEY} \
		-CAcreateserial \
		-extfile <(mkext ${1}) \
		-extensions crt \
		-in "${CERT}.csr" \
		-out ${CERT}
}

function mkca() {
	SUBJECT=${1}
	KEY=${2}
	CERT=${3}
	openssl genrsa -out ${KEY} 4096
	openssl req -new -x509 -nodes -days 36500 \
		-subj "${SUBJECT}" \
		-config <(mkconf) \
		-extensions v3_ca \
		-key ${KEY} \
		-out ${CERT}
}

function mksecret() {
	NAME=${1}
	KEY=${2}
	CERT=${3}
	CA_CERT=${4}
	kubectl create secret generic ${NAME} \
		--from-file=${KEY} \
		--from-file=${CERT} \
		--from-file=${CA_CERT}
}

mkdir ${TEMPDIR}
mkca "${BASEDN}/CN=${SERVER}" "${TEMPDIR}/ca.key" "${TEMPDIR}/ca.crt"
for CLIENT in ${CLIENTS}
do
	mkcert "${BASEDN}/CN=${CLIENT}" \
		"${TEMPDIR}/${CLIENT}.key" "${TEMPDIR}/${CLIENT}.crt" \
		"${TEMPDIR}/ca.key" "${TEMPDIR}/ca.crt"
	mksecret "${SERVER}-${CLIENT}" \
		"${TEMPDIR}/${CLIENT}.key" "${TEMPDIR}/${CLIENT}.crt" \
		"${TEMPDIR}/ca.crt"
done
