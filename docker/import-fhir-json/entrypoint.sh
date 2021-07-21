#!/usr/bin/env bash

trap ctrl_c INT

function ctrl_c() {
	echo 'Done been interrupted, shutting down...'
	exit 0
}

SLEEP_FOR="${SLEEP_FOR:-10}"


IMPORT_CMD=$(cat <<EOF
/usr/local/bin/python /${WORKDIR_PATH}/importFHIR.py \
	--server ${FHIR_SERVER} \
	--original-server ${FHIR_SERVER}
	--folder ${FHIR_FOLDER} \
	--auth-type ${FHIR_AUTH_TYPE} \
	--fhirversion ${FHIR_VERSION} \
	--database-name ${FHIR_DB_NAME}
EOF
)

echo "Command we'll be executing: ${IMPORT_CMD}"

for (( ; ; ))
do
	echo "Sleeping for ${SLEEP_FOR} seconds..."
	sleep "${SLEEP_FOR}"
	set -e
	${IMPORT_CMD}
	set +e
done