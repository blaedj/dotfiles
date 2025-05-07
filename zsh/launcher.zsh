#!/bin/zsh

klaunch() {
    supplied_host=$2
    # host=${supplied_host:-"localhost:3443"}
    host=${supplied_host:-"app.kolide-blaed.ngrok.io"}
    case $1 in
        "help")
            echo "please provide the operating system of the launcher host: {mac,centos,ubuntu,persistentmac,macold,local,sudomac,sudomac-persistent}" ;;
        "sudomac" )
            sudo launchctl asuser 0 \
                ~/code/go/src/launcher/build/launcher \
                -root_directory $(mktemp -d) \
                -hostname $host \
                -enroll_secret_path /Users/blaed/code/rails/k2/tmp/enroll_secret_nababe.txt \
                --osqueryd_path "/usr/local/kolide-k2/bin/osqueryd" \
                --insecure \
                --insecure_transport \
                -transport jsonrpc \
                -autoupdate \
                -update_channel="beta" \
                -debug \
                -with_initial_runner \
                -disable_control_tls \
                2>&1 | tee /Users/blaed/tmp/local_sudomac.log ;;

        # for testing permission errors & handling of said errors
        "sudomac-perms" )
            chown blaed ~/tmp/launcher_root_bad_perms
            sudo rm /Users/blaed/tmp/launcher_root_bad_perms/kolide/bin/launcher
            sudo rm /Users/blaed/tmp/launcher_root_bad_perms/kolide/bin/osquery-extension.ext

            cp ~/code/go/launcher/build/launcher /Users/blaed/tmp/launcher_root_bad_perms/kolide/bin/
            cp ~/code/go/launcher/build/osquery-extension.ext /users/blaed/tmp/launcher_root_bad_perms/kolide/bin/

            sudo launchctl asuser 0 \
                 /Users/blaed/tmp/launcher_root_bad_perms/kolide/bin/launcher \
                 -root_directory "/Users/blaed/tmp/launcher_root_bad_perms/kolide" \
                 -hostname $host \
                 -enroll_secret_path /Users/blaed/code/rails/k2/tmp/enroll_secret_nababe.txt \
                 --osqueryd_path "/Users/blaed/tmp/launcher_root_bad_perms/kolide/bin/osqueryd" \
                 --insecure \
                 --insecure_transport \
                 -transport jsonrpc \
                 -autoupdate \
                 -update_channel="beta" \
                 -debug \
                 -with_initial_runner \
                 -disable_control_tls \
                 2>&1 | tee /Users/blaed/tmp/sudomac-perms.log ;;

        "sudomac-persistent" )
            sudo launchctl asuser 0 \
                 ~/code/go/src/launcher/build/launcher \
                 -root_directory ~/tmp/launcherroot-sudo \
                 -hostname $host \
                 -enroll_secret_path /Users/blaed/code/rails/k2/tmp/enroll_secret_nababe.txt \
                 --osqueryd_path "/usr/local/kolide-k2/bin/osqueryd" \
                 --insecure \
                 --insecure_transport \
                 -transport jsonrpc \
                 -autoupdate \
                 -update_channel="stable" \
                 -i-am-breaking-ee-license \
                 -debug \
                 -disable_control_tls \
                 2>&1 | tee /Users/blaed/tmp/local_sudomac.log ;;

        "persistentmac-prod-binary" )
            /usr/local/kolide-k2/bin/launcher \
                -debug \
                -hostname $host \
                -enroll_secret_path ~/code/rails/k2/tmp/enroll_secret_nababe.txt \
                -i-am-breaking-ee-license \
                -transport jsonrpc \
                -osqueryd_path "/usr/local/kolide-k2/bin/osqueryd" \
                -root_directory ~/tmp/launcherroot \
                2>&1 | tee ~/tmp/local_persistent.log ;;

        "persistentmac" )
            ~/code/go/src/launcher/build/darwin.arm64/launcher \
                -debug \
                -hostname $host \
                -enroll_secret_path ~/code/rails/k2/tmp/enroll_secret_nababe.txt \
                -i-am-breaking-ee-license \
                -transport jsonrpc \
                -osqueryd_path "/usr/local/kolide-k2/bin/osqueryd" \
                -root_directory ~/tmp/launcherroot \
                 -autoupdater_initial_delay 0 \
                -autoupdate false \
                -control_request_interval 10s \
                2>&1 | tee ~/tmp/local_persistent.log ;;

        "persistentmac-edilok" )
            # ~/code/go/src/launcher/build/darwin.arm64/launcher \
            /usr/local/kolide-k2/bin/launcher \
                -debug \
                -hostname $host \
                -enroll_secret_path ~/code/rails/k2/tmp/enroll_secret_nababi.txt \
                -i-am-breaking-ee-license \
                -transport jsonrpc \
                -osqueryd_path "/usr/local/kolide-k2/bin/osqueryd" \
                -root_directory ~/tmp/launcherroot-edilok \
                -autoupdate false \
                -control_request_interval 10s \
                2>&1 | tee ~/tmp/edilok_persistent.log ;;

        "mac" )
            /usr/local/kolide-k2/bin/launcher \
                --root_directory $(mktemp -d) \
                --hostname $host \
                --enroll_secret_path ~/code/rails/k2/tmp/enroll_secret_nababe.txt \
                --osqueryd_path "/usr/local/kolide-k2/bin/osqueryd" \
                --transport jsonrpc \
                --debug \
                --control \
                --control_hostname $host \
                --control_request_interval 5s \
            2>&1 | tee ~/tmp/local.log ;;

        "mac-localbuild" )
            ~/code/go/src/launcher/build/launcher \
                --root_directory $(mktemp -d) \
                --hostname $host \
                --enroll_secret_path ~/code/rails/k2/tmp/enroll_secret_nababe.txt \
                --osqueryd_path "/usr/local/kolide-k2/bin/osqueryd" \
                --transport jsonrpc \
                --debug \
                --i-am-breaking-ee-license
                --control \
                --control_hostname $host \
                --control_request_interval 5s \
                2>&1 | tee ~/tmp/local.log ;;

        "ngrok-mac" )
            ~/code/go/src/launcher/build/launcher \
                --root_directory $(mktemp -d) \
                --hostname $host \
                --enroll_secret_path ~/code/rails/k2/tmp/enroll_secret_nababe.txt \
                --osqueryd_path "/usr/local/kolide-k2/bin/osqueryd" \
                --transport jsonrpc \
                --debug \
                --control \
                --control_hostname $host \
                --control_request_interval 5s \
                --i-am-breaking-ee-license true
                2>&1 | tee ~/tmp/local_ngrok.log ;;
        "macproxied" )
            ~/code/go/launcher/build/launcher \
                -root_directory $(mktemp -d) \
                -hostname localhost:5500 \
                -enroll_secret_path ~/code/rails/k2/tmp/enroll_secret_nababe.txt \
                --insecure \
                --insecure_transport \
                --osqueryd_path "/usr/local/kolide-k2/bin/osqueryd" \
                -transport jsonrpc \
                -autoupdate \
                -debug \
                -with_initial_runner \
                -disable_control_tls \
                2>&1 | tee ~/tmp/local.log ;;

        "local")
            sudo ~/code/go/launcher/build/launcher \
                 -root_directory $(mktemp -d) \
                 -hostname blaedj.ngrok.io \
                 -enroll_secret_path ~/Dropbox/Temp/lnchrscrt.txt \
                 --insecure \
                 --insecure_transport \
                 --osqueryd_path "/usr/local/kolide-k2/bin/osqueryd" \
                 -transport jsonrpc \
                 -autoupdate \
                 -autoupdater_initial_delay 0 \
                 -update_channel beta\
                 -debug \
                 -with_initial_runner \
                 -disable_control_tls \
                 2>&1 | tee ~/tmp/local.log ;;

        "ubuntu" )
            docker run -i --platform linux/amd64 \
                   -t gcr.io/kolide-public-containers/launcher-fakedata-ubuntu18:latest \
                   -debug \
                   -hostname host.docker.internal:3000 \
                   -transport jsonrpc \
                   -enroll_secret $(cat ~/code/rails/k2/tmp/enroll_secret_nababe.txt) \
                   -insecure_transport \
                   -insecure ;;
        "centos" )
            docker run -i --platform linux/amd64 \
                   -t gcr.io/kolide-public-containers/launcher-fakedata-centos7:latest \
                   -debug \
                   -hostname host.docker.internal:3000 \
                   -transport jsonrpc \
                   -enroll_secret $(cat ~/code/rails/k2/tmp/enroll_secret_nababe.txt) \
                   -insecure_transport \
                   -insecure \
                   -disable_control_tls ;;
        "mac-osquery" )
           ~/code/go/src/launcher/build/launcher \
               -root_directory $(mktemp -d) \
               -hostname localhost:3443 \
               -enroll_secret_path ~/code/rails/k2/tmp/enroll_secret_nababe.txt \
               -root_pem ~/code/rails/k2/tmp/localhost.crt \
               -osqueryd_path /usr/local/kolide-k2/bin/osqueryd \
               -kolide_hosted \
               -transport "osquery" \
               -autoupdate \
               -update_channel="beta" \
               -debug ;;
        *)
            echo "please provide the operating system of the launcher host: {mac,centos,ubuntu,local,persistentmac,sudomac,sudomac-persistent}" ;;
    esac
}
