#!/bin/env bash
# curl -sSL https://raw.githubusercontent.com/jez/bask/master/src/bask.sh > .bask.sh
source .bask.sh

bask_default_task="usage"

export DOCFX_VERSION=2.51

task_usage() {
        bask_list_tasks
}

task_build() {
        docker build . \
                -t foonsoft/docker-docfx \
                --build-arg DOCFX_VERSION
}

task_amd64() {
        docker build . \
                -t foonsoft/docker-docfx:${DOCFX_VERSION}.amd64 \
                --build-arg DOCFX_VERSION \
                --build-arg BUILDARCH=amd64

        docker tag \
                foonsoft/docker-docfx:${DOCFX_VERSION}.amd64 \
                foonsoft/docker-docfx:amd64

        docker tag \
                foonsoft/docker-docfx:amd64 \
                foonsoft/docker-docfx
}

task_arm64() {
        docker build . \
                -t foonsoft/docker-docfx:${DOCFX_VERSION}.arm64 \
                --build-arg DOCFX_VERSION \
                --build-arg BUILDARCH=arm64

        docker tag \
                foonsoft/docker-docfx:${DOCFX_VERSION}.arm64 \
                foonsoft/docker-docfx:arm64
}

task_publish() {
        bask_sequence amd64 arm64

        docker push \
                foonsoft/docfx-docfx
                foonsoft/docfx-docfx:amd64
                foonsoft/docfx-docfx:${DOCFX_VERSION}.amd64
                foonsoft/docfx-docfx:arm64
                foonsoft/docfx-docfx:${DOCFX_VERSION}.arm64
}

