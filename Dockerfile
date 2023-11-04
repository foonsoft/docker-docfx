
ARG MONO_ARCH=${TARGETARCH}

FROM mono:6.8 as mono-amd64
FROM arm64v8/mono:6.8 as mono-arm64

FROM alpine:latest as docfx-package

ARG DOCFX_VERSION=2.51

RUN apk add -U wget unzip \
 && mkdir -p /tmp/docfx \
 && wget https://github.com/dotnet/docfx/releases/download/v${DOCFX_VERSION}/docfx.zip -O /tmp/docfx.zip \
 && unzip /tmp/docfx.zip -d /tmp/docfx

FROM mono-${MONO_ARCH} as docfx-base

RUN apt-get update \
 && apt-get install -y \
                    --no-install-recommends \
                    --no-install-suggests \
                    git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && adduser \
        --home /nonexistent \
        --shell /bin/false \
        --no-create-home \
        --gecos "" \
        --disabled-password \
        --disabled-login \
        docfx

COPY --from=docfx-package --chown=docfx:docfx /tmp/docfx /opt/docfx

FROM docfx-base as docfx

USER docfx

EXPOSE 8080

ENTRYPOINT ["/usr/bin/mono", "/opt/docfx/docfx.exe"]

# https://github.com/dotnet/docfx/issues/3615
FROM docfx-base as docfx-nginx-serve

RUN apt-get update \
 && apt-get install -y nginx

COPY entrypoint.sh /entrypoint.sh
#COPY nginx.conf /etc/nginx/nginx.conf

RUN chmod 755 /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["bash", "/entrypoint.sh"]

