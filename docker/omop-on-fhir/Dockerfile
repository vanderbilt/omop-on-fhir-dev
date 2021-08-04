ARG MAVEN_VERSION="${MAVEN_VERSION}"

# staging container where all our lovely code is downloaded.
FROM debian:buster-slim as staging

# args!
ARG GH_PRJ_URL="https://github.com/omoponfhir"
ARG GH_ARC_PATH="archive/refs/heads"
ARG FHIR_VERSION="${FHIR_VERSION:-dstu2}"

# get wget on this bugger
RUN apt update && \
	apt install -y \
		git

##### Using GIT
RUN git clone "https://github.com/omoponfhir/omoponfhir-main-${FHIR_VERSION}.git" \
	&& cd "omoponfhir-main-${FHIR_VERSION}" \
	&& git submodule init \
	&& git submodule update

FROM maven:${MAVEN_VERSION}-alpine as builder

# args!
ARG FHIR_VERSION="${FHIR_VERSION:-dstu2}"
ARG WORKDIR_PATH="/usr/src/app"

# copy in un-zipped source from staging container
# note: i do this as mv that comes with busybox-utils tries to be "helpful" and just gets in my way.
COPY --from=staging "/omoponfhir-main-${FHIR_VERSION}" "${WORKDIR_PATH}"

# set working directory for rest of stage
WORKDIR "${WORKDIR_PATH}"

# build the thing
RUN mvn clean install

# Build the Tomcat container
FROM tomcat:alpine

# args!
ARG FHIR_VERSION="${FHIR_VERSION:-dstu2}"
ARG WAR_NAME="${WAR_NAME:-omoponfhir2}"
ARG WORKDIR_PATH="/usr/src/app"

ARG CATALINA_HOME="${CATALINA_HOME}"

# set environment variables below and uncomment the line. Or, you can manually set your environment on your server.
#ENV JDBC_URL=jdbc:postgresql://<host>:<port>/<database> JDBC_USERNAME=<username> JDBC_PASSWORD=<password>
RUN apk add --update --no-cache \
		postgresql-client \
		zip

# TODO: is zip actually necessary?

# Copy GT-FHIR war file to webapps.
COPY --from=builder "${WORKDIR_PATH}/omoponfhir-${FHIR_VERSION}-server/target/omoponfhir-${FHIR_VERSION}-server.war" "${CATALINA_HOME}/webapps/${WAR_NAME}.war"

# fetch wait-for-it.sh
RUN wget -O /opt/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
	chmod u+x /opt/wait-for-it.sh

EXPOSE 8080

ENTRYPOINT ["bash", "-c", "/opt/wait-for-it.sh omop-on-fhir-pg:5432 --strict --timeout=3600 -- catalina.sh run"]