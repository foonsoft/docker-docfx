#!/bin/env bash
# curl -sSL https://raw.githubusercontent.com/jez/bask/master/src/bask.sh > .bask.sh
source .bask.sh

bask_default_task="usage"

export DOCFX_ARCH_ALL="amd64 arm64"
export DOCFX_VERSIONS="2.51 2.50"
export DOCFX_VERSION_LATEST=2.51

task_usage() {
        bask_list_tasks
}

task_init() {
        bask_run docker run \
                -v $(ospath $(pwd)):/work -w /work \
                --rm foonsoft/docker-docfx \
                init -q -o ./DocfxSample
}

task_serve() {
        bask_run docker run \
                -v $(ospath $(pwd)):/work -w /work -p 8080:8080 -it \
                --rm foonsoft/docker-docfx \
                nginx-serve ./DocfxSample/docfx.json
}

task_doc() {
        bask_run docker run \
                -v $(ospath $(pwd)):/work -w /work \
                --rm foonsoft/docker-docfx \
                build ./DocfxSample/docfx.json
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
        bask_sequence cleanup
        bask_sequence all
        docker push --all-tags foonsoft/docker-docfx
}

task_cleanup() {
        docker rmi --force $(docker images -q foonsoft/docker-docfx) || :
}

task_all() {
        bask_sequence ${DOCFX_ARCH_ALL}
        bask_run tag ${DOCFX_VERSION_LATEST} amd64 latest
}

task_amd64() {
        bask_run build_versions "${DOCFX_VERSIONS}" amd64
        bask_run tag ${DOCFX_VERSION_LATEST} amd64 amd64
}

task_arm64() {
        bask_run build_versions "${DOCFX_VERSIONS}" arm64
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
                --target docfx-nginx-serve \
                --build-arg DOCFX_VERSION=${version} \
                --build-arg MONO_ARCH=${arch}
}

tag() {
        local version=${1}
        local arch=${2}
        local new_tag=${3}

        docker tag \
                foonsoft/docker-docfx:${version}.${arch} \
                foonsoft/docker-docfx:${new_tag}
}

ospath() {
        case ${OSTYPE} in
        cygwin)
                echo $(cygpath -w "${1}")
                ;;
        *)
                echo "${1}"
                ;;
        esac
}

