case ${1} in
build)
        docker build . -t foonsoft/docfx
        ;;
amd64)
        docker buildx build . -t foonsoft/docfx:amd64 --platform linux/amd64
        ;;
arm64)
        docker buildx build . -t foonsoft/docfx:arm64 --platform linux/arm64
        ;;
*)
        docker run -ti --rm -p 8080:8080 --name foonsoft/docfx -v $(pwd):/work -w /work docfx
        ;;
esac
