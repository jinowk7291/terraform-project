#!/bin/bash

#5분마다 체크
starttime=$(date "+%s")
starttime=$(($starttime - 300))
starttime=$(($starttime * 1000))
endtime=$(date "+%s")
endtime=$(($endtime * 1000))
task_name=CW_log_$(date "+%Y-%m-%d-%M-%S")

aws logs create-export-task --profile terraform --task-name ${task_name} --log-group-name "/aws/containerinsights/terraformEKScluster/performance" --from ${starttime} --to ${endtime} --destination "cass-terraform-bucket" --destination-prefix "export-task-output"
