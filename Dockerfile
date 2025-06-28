ARG IMAGE=debian
ARG TAG=latest

FROM ${IMAGE}:${TAG}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        qemu-system-x86 \
        qemu-utils \
        novnc \
        websockify \
        wget \
        curl \
        net-tools \
        unzip \
        python3 \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data /iso / novnc

RUN wget https://github.com/novnc/noVNC/archive/refs/heads/master.zip -O /tmp/novnc.zip && \
    unzip /tmp/novnc.zip -d /tmp && \
    mv /tmp/noVNC-master/* /novnc && \
    rm -rf /tmp/novnc.zip /tmp/noVNC-master

COPY ./start.sh /start.sh
RUN chmod +x /start.sh

VOLUME [ "/data", "/iso" ]
EXPOSE 6080 3389

ENTRYPOINT [ "/start.sh" ]