# omop-on-fhir-dev
OMOP on FHIR dev environment

## Basic Setup

1. Place any / all FHIR json files you'd like processed under the `files-fhir` directory
1. Place the latest csv files from Athena in `files-athena`
1. `docker-compose up --abort-on-container-exit`

First boot will take _quite_ some time as the vocab is loaded.