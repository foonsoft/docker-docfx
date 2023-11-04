case "${1}" in
nginx-serve)
        shift
        /usr/sbin/nginx
        sleep 5
        /usr/bin/mono /opt/docfx/docfx.exe "${@}" --serve -n0.0.0.0 -p8080
        ;;
*)
        /usr/bin/mono /opt/docfx/docfx.exe "${@}"
        ;;
esac
