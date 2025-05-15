FROM debian:12-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    extrepo \
    && extrepo enable helm \
    && extrepo enable kubernetes \
    && rm -rf /var/lib/apt/lists/*

ARG HELM_VERSION=3.12.2-1

RUN apt update && \
    apt install --no-install-recommends -y \
    git \
    wget \
    awscli \
    make \
    kubectl \
    helm="$HELM_VERSION" \
    && rm -rf /var/lib/apt/lists/*

ARG TARGETPLATFORM=linux/amd64

# Ref: https://github.com/carvel-dev/kapp/releases/tag/v0.57.0
ARG KAPP_VERSION=0.57.0
ARG KAPP_CHECKSUM="f71adcf7292aa5a38f4fd8925bec27ab3af61e24e2eed122cb4856381c17efc1"

RUN cd /usr/local/bin \
    && wget -nv -O kapp \
    "https://github.com/carvel-dev/kapp/releases/download/v${KAPP_VERSION}/kapp-${TARGETPLATFORM%/*}-${TARGETPLATFORM#*/}" \
    && echo "${KAPP_CHECKSUM}  kapp" | shasum -ca 256 - \
    && chmod +x kapp
