FROM mono:6.8 as build-amd64
FROM arm64v8/mono:6.8 as build-arm64

FROM alpine:latest as docfx-package

ARG DOCFX_VERSION=2.51

RUN apk add -U wget unzip \
 && mkdir -p /tmp/docfx \
 && wget https://github.com/dotnet/docfx/releases/download/v${DOCFX_VERSION}/docfx.zip -O /tmp/docfx.zip \
 && unzip /tmp/docfx.zip -d /tmp/docfx

FROM build-${TARGETARCH}

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

USER docfx

EXPOSE 8080

ENTRYPOINT ["/usr/bin/mono", "/opt/docfx/docfx.exe"]
