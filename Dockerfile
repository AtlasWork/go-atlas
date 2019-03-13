# Build Geth in a stock Go builder container
FROM golang:1.11-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers
RUN go get github.com/AtlasWork/go-atlas

ADD . /go-atlas
RUN cd /go-atlas && make geth

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-atlas/build/bin/geth /usr/local/bin/

EXPOSE 57200 57200 30303 30303/udp 30304/udp
ENTRYPOINT ["geth", "init", "--datadir ~/.atlaschain" , "../../AtlasGenesisMainNet.json"]
ENTRYPOINT ["geth", "--datadir ~/.atlaschain/",  "--networkid 9082075", "--port 57200", "--rpcport 8080", "console", "--fast", "--cache=512"]
