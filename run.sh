#!/bin/env bash
# curl -sSL https://raw.githubusercontent.com/jez/bask/master/src/bask.sh > .bask.sh
source .bask.sh

bask_default_task="usage"

export DOCFX_ARCH_ALL=amd64 arm64
export DOCFX_VERSIONS=2.51
export DOCFX_VERSION_LATEST=2.51

task_usage() {
        bask_list_tasks
}

task_build() {
        case ${OSTYPE} in
        darwin*)
                bask_run build ${DOCFX_VERSION_LATEST} arm64
                bask_run tag ${DOCFX_VERSION_LATEST} arm64 latest
                ;;
        *)
                bask_run build ${DOCFX_VERSION_LATEST} amd64
                bask_run tag ${DOCFX_VERSION_LATEST} amd64 latest
                ;;
        esac
}

task_publish() {
        docker rmi --force $(docker images -q foonsoft/docker-docfx) || :
        bask_sequence all
        docker push --all-tags foonsoft/docker-fx
}

task_all() {
        bask_sequence ${DOCFX_ARCH_ALL}
        bask_run tag ${DOCFX_VERSION_LATEST} amd64 latest
}

task_amd64() {
        bask_run build_versions ${DOCFX_VERSIONS} amd64
        bask_run tag ${DOCFX_VERSION_LATEST} amd64 amd64
}

task_arm64() {
        bask_run build_versions ${DOCFX_VERSIONS} arm64
        bask_run tag ${DOCFX_VERSION_LATEST} arm64 arm64
}

build_versions() {
        local versions=${1}
        local arch=${2}

        for v in ${versions} ; do
                bask_run build ${v} ${arch}
        done
}

build() {
        local version=${1}
        local arch=${2}

        docker build . \
                -t foonsoft/docker-docfx:${version}.${arch} \
                --build-arg DOCFX_VERSION=${version} \
                --build-arg BUILDARCH=${arch}
}

tag() {
        local version=${1}
        local arch=${2}
        local new_tag=${3}

        docker tag \
                foonsoft/docker-docfx:${version}.${arch} \
                foonsoft/docker-docfx${new_tag:-:}${new_tag}
}

