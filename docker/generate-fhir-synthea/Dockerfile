# switch to gradle
FROM openjdk:18-slim

# install wget
RUN apt-get update \
    && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/*

# Download the latest synthea jar file.
# Branch passed via ENV variable from docker-compose
#Need ARG and ENV declarations
ARG SYNTHEA_BRANCH
ENV SYNTHEA_BRANCH=${SYNTHEA_BRANCH}
#RUN wget https://github.com/synthetichealth/synthea/releases/download/master-branch-latest/synthea-with-dependencies.jar
RUN wget --quiet "https://github.com/synthetichealth/synthea/releases/download/${SYNTHEA_BRANCH}/synthea-with-dependencies.jar"

# Set properties needed
COPY ./synthea.properties ./

# Set up the jar file and number of files as params via CMD.
# Can be overridden in the docker-compose file.
ARG NUMBER_OF_FILES
ENV NUMBER_OF_FILES=${NUMBER_OF_FILES}
#ENTRYPOINT ["java", "-jar", "${SYNTHEA_FILE}.jar"]
ENTRYPOINT [ "java" ]
CMD ["-jar", "/synthea-with-dependencies.jar", "-p", "25", "-c", "/synthea.properties"]

