FROM golang:latest
RUN apt-get update
RUN apt-get install -y build-essential redis-server
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh \
  | sh -s -- -b $(go env GOPATH)/bin v1.27.0

# Update redis config to work with upstart-sysv
RUN sed -i 's/supervised no/supervised upstart/g' /etc/redis/redis.conf

# Start the service on container startup
ENTRYPOINT service redis-server start && /bin/bash

# To use this to run tests, run the following
# commands from the root of the project directory:
# // The following commands are run locally
# docker build -t go-redis-test-container .
# docker run -it --rm -v "$PWD:/app" go-redis-test-container
# // You will now be in a shell in the container
# cd /app
# make
