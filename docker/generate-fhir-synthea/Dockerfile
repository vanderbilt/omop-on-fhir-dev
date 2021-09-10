# switch to gradle
FROM gradle:7-jdk

# install git
# don't need apk - won't work with ubuntu
# Use apt-get instead
RUN apt-get update \
    && apt-get install -y wget unzip \
    && rm -rf /var/lib/apt/lists/*

# Download the latest synthea jar file.
# Passed via ENV variable from docker-compose
#env_var synthea_version
#Need ARG and ENV declarations
ARG SYNTHEA_BRANCH
ENV SYNTHEA_BRANCH=${SYNTHEA_BRANCH}
ARG SYNTHEA_FILE
ENV SYNTHEA_FILE=${SYNTHEA_FILE}
#RUN wget https://github.com/synthetichealth/synthea/releases/download/master-branch-latest/synthea-with-dependencies.jar
RUN wget "https://github.com/synthetichealth/synthea/releases/download/${SYNTHEA_BRANCH}/${SYNTHEA_FILE}.jar"

# Set properties needed
#COPY ./synthea.properties ./

# Set up the jar file and number of files as params via CMD.
# Can be overridden in the docker-compose file.
ARG NUMBER_OF_FILES
ENV NUMBER_OF_FILES=${NUMBER_OF_FILES}
#ENTRYPOINT ["java", "-jar", "${SYNTHEA_FILE}.jar"]
ENTRYPOINT ["java", "-jar", "synthea-with-dependencies.jar", \
            "--exporter.fhir_dstu2.export",  "true", \
            "--exporter.fhir.export", "false", \
            "--exporter.hospital.fhir_dstu2.export", "false", \
            "--exporter.hospital.fhir.export", "false" ]
CMD ["-p", "20"]
#, "-m", "medications*"]

