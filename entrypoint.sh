case "${1}" in
nginx-serve)
        shift
        /usr/sbin/nginx
        echo "nginx running on port 8080."
        /usr/bin/mono /opt/docfx/docfx.exe "${@}" --serve -nlocalhost -p18080
        ;;
*)
        /usr/bin/mono /opt/docfx/docfx.exe "${@}"
        ;;
esac
