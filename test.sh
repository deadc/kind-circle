#!/bin/bash

attempt_counter=0
max_attempts=6
check=0

while [ ${check} -lt 3 ] ; do
    if [ ${attempt_counter} -eq ${max_attempts} ];then
      echo -e "\nMax attempts reached"
      exit 1
    fi

    printf '.'
    attempt_counter=$(($attempt_counter+1))
    check=$( ./kubectl get pods --namespace test --field-selector=status.phase=Running 2> /dev/null | grep -i httpbin | wc -l )
    sleep 5
done
