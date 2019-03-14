# Build Geth in a stock Go builder container
FROM golang:1.11-alpine as builder

RUN apk update && apk upgrade && \
    apk add --no-cache bash git
    
RUN apk add build-base gcc abuild binutils binutils-doc gcc-doc

RUN go get github.com/AtlasWork/go-atlas

RUN \
  apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 https://github.com/AtlasWork/go-atlas && \
  (cd go-atlas && make all) && \
  cp go-atlas/AtlasGenesisMainNet.json /geth && \
  cp go-atlas/build/bin/geth /geth && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-atlas && rm -rf /var/cache/apk/*

EXPOSE 8080
EXPOSE 57200
EXPOSE 30303
EXPOSE 57200 57200 30303 30303/udp 30304/udp


ENTRYPOINT ["geth", "init", "--datadir ~/.atlaschain" , "./geth/AtlasGenesisMainNet.json"]
ENTRYPOINT ["geth", "--datadir ~/.atlaschain/",  "--networkid 9082075", "--port 57200", "--rpcport 8080", "console", "--fast", "--cache=512"]
