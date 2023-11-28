#!/usr/bin/env bash

export IMAGE_NAME=$1

# Read values from Jenkins environment variables
MYSQL_HOST=$RDS_ENDPOINT
MYSQL_USER=$DB_USERNAME
MYSQL_ROOT_PASSWORD=$DB_PASSWORD
MYSQL_DATABASE=$DB_NAME

# Run Docker container with environment variables
docker run -p 5000:5000 \
  -e MYSQL_HOST=${MYSQL_HOST} \
  -e MYSQL_USER=${MYSQL_USER} \
  -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
  -e MYSQL_DATABASE=${MYSQL_DATABASE} \
  ${IMAGE_NAME}

echo "success"
