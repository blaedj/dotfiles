#!/bin/zsh

# different secrets need to be generated for diff. envs.
# use
# ./build/cloudctl create enroll-secret --tenant dibado >  ~/tmp/master_secret
# for master,
# ./build/cloudctl create enroll-secret --tenant dababi >  ~/tmp/pr_secret
# for PRs, and
# ./build/cloudctl create enroll-secret --tenant dababi >  ~/tmp/local_secret
# for local.

k1launch() {
    case $1 in
        "master" )
            ~/code/go/launcher/build/launcher \
                -root_directory ~/tmp/master \
                -hostname dibado.launcher.kolide.net:443 \
                -enroll_secret_path ~/tmp/master_secret \
                -debug  | tee ~/tmp/master.log ;;
        [0-9]*)
            ~/code/go/launcher/build/launcher \
                -root_directory $(mktemp -d) \
                -hostname $1.cloud.kolide.net:443 \
                -enroll_secret_path ~/tmp/pr_secret \
                -debug | tee ~/tmp/$1.log ;;
        *)
            ~/code/go/launcher/build/launcher \
                -root_directory $(mktemp -d) \
                -hostname localhost:8800 \
                -enroll_secret_path ~/tmp/local_secret \
                -debug \
                -insecure_transport \
                -insecure \
                2>&1 | tee ~/tmp/local.log ;;
    esac
}

klaunch() {
    supplied_host=$2
    host=${supplied_host:-"localhost:3443"}
    case $1 in
        "help")
            echo "please provide the operating system of the launcher host: {mac,centos,ubuntu,macold,local,sudomac,sudomac-persistent}" ;;
        "sudomac" )
            sudo launchctl asuser 0 \
                ~/code/go/src/launcher/build/launcher \
                -root_directory $(mktemp -d) \
                -hostname $host \
                -enroll_secret_path /Users/blaed/code/rails/k2/tmp/secret.txt \
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
                 -enroll_secret_path /Users/blaed/code/rails/k2/tmp/secret.txt \
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
                 -enroll_secret_path /Users/blaed/code/rails/k2/tmp/secret.txt \
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

        "persistentmac-prod-binary" )
                /usr/local/kolide-k2/bin/launcher \
                    -root_directory ~/tmp/launcherroot \
                    -hostname $host \
                    -enroll_secret_path ~/code/rails/k2/tmp/secret.txt \
                    --osqueryd_path "/usr/local/kolide-k2/bin/osqueryd" \
                    -transport jsonrpc \
                    -debug \
                    -control \
                    -control_hostname $host \
                    -control_request_interval 5s \
                    -root_pem /Users/blaed/code/rails/k2/tmp/localhost.crt \
                    2>&1 | tee ~/tmp/local_persistent.log ;;

        "persistentmac" )
            ~/code/go/src/launcher/build/launcher \
                -root_directory ~/tmp/launcherroot \
                -hostname $host \
                -enroll_secret_path ~/code/rails/k2/tmp/secret.txt \
                --osqueryd_path "/usr/local/kolide-k2/bin/osqueryd" \
                -transport jsonrpc \
                -debug \
                -control \
                -control_hostname $host \
                -control_request_interval 5s \
                -root_pem /Users/blaed/code/rails/k2/tmp/localhost.crt \
                2>&1 | tee ~/tmp/local_persistent.log ;;

        "mac" )
            /usr/local/kolide-k2/bin/launcher \
                --root_directory $(mktemp -d) \
                --hostname $host \
                --enroll_secret_path ~/code/rails/k2/tmp/secret.txt \
                --osqueryd_path "/usr/local/kolide-k2/bin/osqueryd" \
                --transport jsonrpc \
                --debug \
                --control \
                --control_hostname $host \
                --control_request_interval 5s \
                --root_pem /Users/blaed/code/rails/k2/tmp/localhost.crt \
            2>&1 | tee ~/tmp/local.log ;;

        "mac-localbuild" )
            !/code/go/src/launcher/build/launcher \
                --root_directory $(mktemp -d) \
                --hostname $host \
                --enroll_secret_path ~/code/rails/k2/tmp/secret.txt \
                --osqueryd_path "/usr/local/kolide-k2/bin/osqueryd" \
                --transport jsonrpc \
                --debug \
                --i-am-breaking-ee-license
                --control \
                --control_hostname $host \
                --control_request_interval 5s \
                --root_pem /Users/blaed/code/rails/k2/tmp/localhost.crt \
                2>&1 | tee ~/tmp/local.log ;;

        "ngrok-mac" )
            ~/code/go/src/launcher/build/launcher \
                --root_directory $(mktemp -d) \
                --hostname $host \
                --enroll_secret_path ~/code/rails/k2/tmp/secret.txt \
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
                -enroll_secret_path ~/code/rails/k2/tmp/secret.txt \
                --insecure \
                --insecure_transport \
                --osqueryd_path "/usr/local/kolide-k2/bin/osqueryd" \
                -transport jsonrpc \
                -autoupdate \
                -debug \
                -with_initial_runner \
                -disable_control_tls \
                2>&1 | tee ~/tmp/local.log ;;
        "macold" )
            ~/tmp/oldlauncher \
                -root_directory $(mktemp -d) \
                -hostname localhost:3000 \
                -enroll_secret_path ~/code/rails/k2/tmp/secret.txt \
                --insecure \
                --insecure_transport \
                -transport jsonrpc \
                --debug true \
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
                   -enroll_secret $(cat ~/code/rails/k2/tmp/secret.txt) \
                   -insecure_transport \
                   -insecure ;;
        "centos" )
            docker run -i --platform linux/amd64 \
                   -t gcr.io/kolide-public-containers/launcher-fakedata-centos7:latest \
                   -debug \
                   -hostname host.docker.internal:3000 \
                   -transport jsonrpc \
                   -enroll_secret $(cat ~/code/rails/k2/tmp/secret.txt) \
                   -insecure_transport \
                   -insecure \
                   -disable_control_tls ;;
        "mac-osquery" )
           ~/code/go/src/launcher/build/launcher \
               -root_directory $(mktemp -d) \
               -hostname localhost:3443 \
               -enroll_secret_path ~/code/rails/k2/tmp/secret.txt \
               -root_pem ~/code/rails/k2/tmp/localhost.crt \
               -osqueryd_path /usr/local/kolide-k2/bin/osqueryd \
               -kolide_hosted \
               -transport "osquery" \
               -autoupdate \
               -update_channel="beta" \
               -debug ;;
        *)
            echo "please provide the operating system of the launcher host: {mac,centos,ubuntu,macold,local,sudomac,sudomac-persistent}" ;;
    esac
}
