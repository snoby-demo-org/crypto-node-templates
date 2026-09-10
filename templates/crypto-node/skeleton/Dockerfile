# ${{ values.coinName }} Core node (with ZMQ)
# Builds from the LOCAL source tree (./${{ values.sourceDir }}).
FROM ubuntu:24.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && rm -rf /var/lib/apt/lists/*

ENV PACKAGES="\
  build-essential pkg-config libtool git autoconf automake \
  libevent-dev libboost-chrono-dev libboost-filesystem-dev libboost-test-dev \
  libboost-thread-dev libssl-dev libzmq3-dev libdb++-dev libsqlite3-dev \
  libfmt-dev help2man bsdmainutils python3 patch \
"
RUN apt-get update && apt-get install --no-install-recommends -y $PACKAGES && rm -rf /var/lib/apt/lists/* && apt-get clean

WORKDIR /src
COPY ${{ values.sourceDir }}/ /src/
COPY patches/ /patches/

RUN for p in /patches/*.patch; do \
      [ -e "$p" ] || continue; \
      echo "Applying $p"; patch -p1 -d /src < "$p" || exit 1; \
    done

WORKDIR /src
RUN ./autogen.sh && \
    ./configure --disable-tests --without-gui --enable-zmq --disable-upnp --prefix=/build && \
    make -j$(nproc) -C src ${{ values.binaryName | replace(",", " ") }} && \
    mkdir -p /build/bin && \
    cp ${{ values.binaryName | replace(",", " ") }} /build/bin/

FROM ubuntu:24.04
WORKDIR /usr/local/
COPY --from=builder /build/ /usr/local/
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates libzmq5 && rm -rf /var/lib/apt/lists/*

VOLUME ["/data", "/root/.${{ values.coinName | lower }}/${{ values.coinName | lower }}.conf"]

EXPOSE ${{ values.p2pPort }} ${{ values.rpcPort }} 28332 28333 28334 28335

ENV NODE_BINS="${{ values.binaryName | replace(",", " ") }}"
ENTRYPOINT ["/bin/sh", "-c", "set -- $NODE_BINS; exec /usr/local/bin/$1 \"$@\"", "sh"]
