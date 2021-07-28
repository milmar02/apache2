config_path=${CONFIG_PATH:-/config}
dest_path=${HTTPD_CONFIG_PATH:-/etc/apache2}

destfilename() {
    sourcefile=$1
    prefix=$2

    echo $(echo $(basename $sourcefile) | sed "s/^$prefix-//")
}

if [ -d $config_path ]; then
    for f in $(find ${config_path} -maxdepth 1 -type f -name "*.conf");do
        case $(basename $f) in
            conf.d-*.conf)
                cp -fv $f $dest_path/conf.d/$(destfilename $f "conf.d")
                ;;
            vhost.d-*.conf)
                cp -fv $f $dest_path/vhost.d/$(destfilename $f "vhost.d")
                ;;
            *)
                cp -fv $f ${dest_path}/
                ;;
        esac
    done
fi
