# function difworker {
#     job=~/code/rails/k2/app/jobs/$1
#     worker=$(echo $job | awk '{gsub("job", "worker")}1')
#     /usr/local/bin/delta $job $worker
# }
