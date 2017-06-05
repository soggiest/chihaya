FROM golang:alpine
MAINTAINER Jimmy Zelinskie <jimmyzelinskie@gmail.com>

# Install OS-level dependencies.
RUN apk update && \
    apk add curl git && \
    curl https://glide.sh/get | sh

# Copy our source code into the container.
WORKDIR /go/src/github.com/chihaya/chihaya
ADD . /go/src/github.com/chihaya/chihaya

# Install our golang dependencies and compile our binary.
RUN glide install
RUN go install github.com/chihaya/chihaya/cmd/chihaya

#RUN awk 'split_after == 1 {n++;split_after=0} /-----END CERTIFICATE-----/ {split_after=1} {print > "/etc/ssl/certs/ca-cert" n ".crt"}' < /etc/ssl/certs/ca-certificates.crt
 

#COPY cert.pem /etc/ssl/certs/cert.crt
#RUN chmod 644 /etc/ssl/certs/cert.crt
#COPY cert1.pem /etc/ssl/certs/cert1.crt
#RUN chmod 644 /etc/ssl/certs/cert1.crt
RUN update-ca-certificates --fresh
# Delete the compiler from the container.
# This makes the container much smaller when using Quay's squashing feature.
RUN rm -r /usr/local/go

# Expose a docker interface to our binary.
EXPOSE 6880 6881
ENTRYPOINT ["chihaya"]
