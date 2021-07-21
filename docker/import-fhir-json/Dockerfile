FROM alpine:3 as builder

# install some deps
RUN apk add --update --no-cache \
	unzip \
	wget

# download some code
RUN wget -O "import-fhir-json.zip" "https://github.com/all-of-us/ImportFhirJson/archive/refs/heads/feature/docker-dev.zip"
RUN wget -O "wait-for-it.sh" "https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh"

# unzip
RUN unzip "import-fhir-json.zip"

# run container
FROM python:3.7-alpine

# args
ARG WORKDIR_PATH="/app/import-fhir-json"

# define some envvars
ENV FHIR_SERVER="${FHIR_SERVER:-http://omop-on-fhir:8080/omoponfhir2/fhir/}"
ENV FHIR_FOLDER="${FHIR_FOLDER:-./test}"
ENV FHIR_AUTH_TYPE="${FHIR_AUTH_TYPE:-basic}"
# in this context, FHIR_VERSION's value must be capitalized for now
ENV FHIR_VERSION="${FHIR_VERSION:-DSTU2}"
ENV FHIR_DB_NAME="${FHIR_DB_NAME:-db/db.sqlite}"
ENV FHIR_USER="${FHIR_USER:-fhirguy}"
ENV FHIR_PASSWORD="${FHIR_PASSWORD:-fhirpass}"
ENV SLEEP_FOR="${SLEEP_FOR:-30}"
ENV WORKDIR_PATH="${WORKDIR_PATH}"

# add deps
RUN apk add --update --no-cache \
	bash \
	sqlite \
	tzdata

# create and move into working directory
WORKDIR "${WORKDIR_PATH}"

# copy in assets from staging container
COPY --from=builder "/ImportFhirJson-feature-docker-dev/DSTU2libs.py" ./
COPY --from=builder "/ImportFhirJson-feature-docker-dev/importFHIR.py" ./
COPY --from=builder "/ImportFhirJson-feature-docker-dev/uploadFiles.py" ./
COPY --from=builder "/ImportFhirJson-feature-docker-dev/requirements.txt" ./
COPY --from=builder "/wait-for-it.sh" ./

RUN chmod u+x wait-for-it.sh

# copy in local assets
COPY "entrypoint.sh" ./

# install deps & such
RUN pip install -r requirements.txt

# we start here.
ENTRYPOINT ["bash", "-c", "${WORKDIR_PATH}/wait-for-it.sh omop-on-fhir:8080 --strict --timeout=3600 -- ${WORKDIR_PATH}/entrypoint.sh"]