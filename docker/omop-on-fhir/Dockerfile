ARG MAVEN_VERSION="${MAVEN_VERSION}"

# staging container where all our code is downloaded.
FROM alpine:3 as staging

# args!
ARG OOF_GH_PRJ_URL="https://github.com/omoponfhir"
ARG OOF_GH_BRANCH="${OOF_GH_BRANCH}"
ARG FHIR_VERSION="${FHIR_VERSION}"

# install git
RUN apk add --update --no-cache \
		git

# 1. clone repo
# 2. check out specific branch / version
# 3. init and pull down any / all submodules
RUN git clone "https://github.com/omoponfhir/omoponfhir-main-${FHIR_VERSION}.git" \
	&& cd "omoponfhir-main-${FHIR_VERSION}" \
	&& git checkout "${OOF_GH_BRANCH}" \
	&& git submodule init \
	&& git submodule update --recursive

FROM maven:${MAVEN_VERSION}-alpine as builder

# update deps
RUN apk update --no-cache

# args!
ARG FHIR_VERSION="${FHIR_VERSION}"
ARG WORKDIR_PATH="/usr/src/app"

# copy in souce code from staging container
# note: i do this as mv that comes with busybox-utils tries to be "helpful" and just gets in my way.
COPY --from=staging "/omoponfhir-main-${FHIR_VERSION}" "${WORKDIR_PATH}"

# set working directory for rest of stage
WORKDIR "${WORKDIR_PATH}"

# build the thing
RUN mvn clean install

# Build the Tomcat container
FROM tomcat:alpine

# args!
ARG FHIR_VERSION="${FHIR_VERSION}"
ARG OOF_WAR_NAME="${OOF_WAR_NAME}"
ARG WORKDIR_PATH="/usr/src/app"

ARG CATALINA_HOME="${CATALINA_HOME}"

# set environment variables below and uncomment the line. Or, you can manually set your environment on your server.
#ENV JDBC_URL=jdbc:postgresql://<host>:<port>/<database> JDBC_USERNAME=<username> JDBC_PASSWORD=<password>
RUN apk add --update --no-cache \
		postgresql-client

# Copy GT-FHIR war file to webapps.
COPY --from=builder "${WORKDIR_PATH}/omoponfhir-${FHIR_VERSION}-server/target/omoponfhir-${FHIR_VERSION}-server.war" "${CATALINA_HOME}/webapps/${OOF_WAR_NAME}.war"

# fetch wait-for-it.sh
RUN wget -O /opt/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
	chmod u+x /opt/wait-for-it.sh

EXPOSE 8080

ENTRYPOINT ["bash", "-c", "/opt/wait-for-it.sh omop-on-fhir-pg:5432 --strict --timeout=3600 -- catalina.sh run"]