FROM ubuntu:xenial

ENV PATH=/usr/lib/go-1.9/bin:$PATH

RUN \
  apt-get update && apt-get upgrade -q -y && \
  apt-get install -y --no-install-recommends golang-1.9 git make gcc libc-dev ca-certificates && \
  git clone --depth 1 https://github.com/AtlasWork/go-atlas && \
  (cd go-atlas && make geth) && \
  cp go-atlas/build/bin/geth /geth && \
  apt-get remove -y golang-1.9 git make gcc libc-dev && apt autoremove -y && apt-get clean && \
  rm -rf /go-atlas

EXPOSE 8080
EXPOSE 57200
EXPOSE 30303
EXPOSE 57200 57200 30303 30303/udp 30304/udp

ENTRYPOINT ["geth", "init", "--datadir ~/.atlaschain" , "/geth/AtlasGenesisMainNet.json"]
ENTRYPOINT ["geth", "--datadir ~/.atlaschain/",  "--networkid 9082075", "--port 57200", "--rpcport 8080", "console", "--fast", "--cache=512"]
