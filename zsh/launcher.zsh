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
            ~/code/go/src/github.com/kolide/launcher/build/launcher \
                -root_directory ~/tmp/master \
                -hostname dibado.launcher.kolide.net:443 \
                -enroll_secret_path ~/tmp/master_secret \
                -debug  | tee ~/tmp/master.log ;;
        [0-9]*)
            ~/code/go/src/github.com/kolide/launcher/build/launcher \
                -root_directory $(mktemp -d) \
                -hostname $1.cloud.kolide.net:443 \
                -enroll_secret_path ~/tmp/pr_secret \
                -debug | tee ~/tmp/$1.log ;;
        *)
            ~/code/go/src/github.com/kolide/launcher/build/launcher \
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
    case $1 in
        "help")
            echo "please provide the operating system of the launcher host: {mac,centos,ubuntu,macold}" ;;
        "sudomac" )
            sudo launchctl asuser 0 \
                ~/code/go/src/github.com/kolide/launcher/build/launcher \
                -root_directory $(mktemp -d) \
                -hostname localhost:5000 \
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

        "sudomac-persistent" )
            sudo launchctl asuser 0 \
                 ~/code/go/src/github.com/kolide/launcher/build/launcher \
                 -root_directory ~/tmp/launcherroot-sudo \
                 -hostname localhost:5000 \
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
        "persistentmac" )
            ~/code/go/src/github.com/kolide/launcher/build/launcher \
                -root_directory ~/tmp/launcherroot \
                -hostname localhost:5000 \
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


        "mac" )
            ~/code/go/src/github.com/kolide/launcher/build/launcher \
                -root_directory $(mktemp -d) \
                -hostname localhost:5000 \
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
        "macproxied" )
            ~/code/go/src/github.com/kolide/launcher/build/launcher \
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
                -hostname localhost:5000 \
                -enroll_secret_path ~/code/rails/k2/tmp/secret.txt \
                --insecure \
                --insecure_transport \
                -transport jsonrpc \
                --debug true \
                -with_initial_runner \
                -disable_control_tls \
                2>&1 | tee ~/tmp/local.log ;;
        "ubuntu" )
            docker run -i -t gcr.io/kolide-public-containers/launcher-fakedata-ubuntu18:latest \
                   -debug \
                   -hostname host.docker.internal:5000 \
                   -control \
                   -control_hostname host.docker.internal:5000 \
                   -transport jsonrpc \
                   -enroll_secret $(cat ~/code/rails/k2/tmp/secret.txt) \
                   -insecure_transport \
                   -insecure \
                   -disable_control_tls ;;
        "centos" )
            docker run -i -t gcr.io/kolide-public-containers/launcher-fakedata-centos7:latest \
                   -debug \
                   -hostname host.docker.internal:5000 \
                   -control \
                   -control_hostname host.docker.internal:5000 \
                   -transport jsonrpc \
                   -enroll_secret $(cat ~/code/rails/k2/tmp/secret.txt) \
                   -insecure_transport \
                   -insecure \
                   -disable_control_tls ;;
    esac
}
